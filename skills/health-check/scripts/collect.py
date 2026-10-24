#!/usr/bin/env python3
"""Collect current Linux health evidence without changing the machine."""

import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import time


def read(path):
    try:
        return Path(path).read_text().strip()
    except OSError:
        return None


def command(*args):
    if not shutil.which(args[0]):
        return {"unavailable": f"{args[0]} is not installed"}
    try:
        result = subprocess.run(
            args, capture_output=True, text=True, timeout=8,
            env={**os.environ, "LC_ALL": "C", "SYSTEMD_COLORS": "0"},
        )
        return {"exit_code": result.returncode, "stdout": result.stdout.strip(),
                "stderr": result.stderr.strip()}
    except (OSError, subprocess.TimeoutExpired) as error:
        return {"unavailable": str(error)}


def cpu_times():
    # guest/guest_nice are already included in user/nice; do not count them twice.
    return list(map(int, Path('/proc/stat').read_text().splitlines()[0].split()[1:9]))


def processes():
    result = {}
    for directory in Path('/proc').iterdir():
        if not directory.name.isdecimal():
            continue
        try:
            stat = (directory / 'stat').read_text()
            end = stat.rindex(')')
            fields = stat[end + 2:].split()
            result[int(directory.name)] = {
                "name": stat[stat.index('(') + 1:end],
                "ticks": int(fields[11]) + int(fields[12]),
                "start": int(fields[19]),
                "rss_gib": round(int(fields[21]) * os.sysconf('SC_PAGE_SIZE') / 2**30, 3),
            }
        except (OSError, ValueError, IndexError):
            # Processes can exit while /proc is being read.
            continue
    return result


def sensors():
    result = {}
    for directory in Path('/sys/class/hwmon').glob('hwmon*'):
        chip = read(directory / 'name') or directory.name
        for pattern, unit, scale in (
            ('temp*_input', 'C', 1000), ('fan*_input', 'RPM', 1),
            ('power*_input', 'W', 1_000_000), ('power*_average', 'W', 1_000_000),
        ):
            for path in directory.glob(pattern):
                raw = read(path)
                if raw is None:
                    continue
                try:
                    value = float(raw) / scale
                except ValueError:
                    continue
                stem = path.name.rsplit('_', 1)[0]
                entry = {"chip": chip, "label": read(directory / f'{stem}_label') or stem,
                         "unit": unit, "value": value}
                if unit == 'C':
                    for limit in ('max', 'crit', 'emergency'):
                        raw_limit = read(directory / f'{stem}_{limit}')
                        try:
                            degrees = float(raw_limit) / 1000
                        except (TypeError, ValueError):
                            continue
                        if 0 < degrees < 200:
                            entry[limit + '_c'] = degrees
                result[f'{directory.name}/{path.name}'] = entry
    return result


def memory():
    fields = {}
    for line in Path('/proc/meminfo').read_text().splitlines():
        key, value = line.split(':', 1)
        fields[key] = int(value.split()[0])
    return {
        "total_gib": round(fields['MemTotal'] / 2**20, 2),
        "used_gib": round((fields['MemTotal'] - fields['MemAvailable']) / 2**20, 2),
        "available_gib": round(fields['MemAvailable'] / 2**20, 2),
        "used_pct": round(100 * (1 - fields['MemAvailable'] / fields['MemTotal']), 1),
        "swap_total_gib": round(fields['SwapTotal'] / 2**20, 2),
        "swap_used_gib": round((fields['SwapTotal'] - fields['SwapFree']) / 2**20, 2),
    }


def swap_counters():
    return {key: int(value) for key, value in
            (line.split() for line in Path('/proc/vmstat').read_text().splitlines())
            if key in ('pswpin', 'pswpout')}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--seconds', type=int, default=30, help='Sample duration, 2–60 seconds')
    args = parser.parse_args()
    if not 2 <= args.seconds <= 60:
        parser.error('--seconds must be between 2 and 60')
    if platform.system() != 'Linux':
        parser.error('This collector requires Linux /proc and /sys')

    started_at = datetime.now().astimezone().isoformat(timespec='seconds')
    start = time.monotonic()
    first_cpu = previous_cpu = cpu_times()
    first_processes = processes()
    first_swap = swap_counters()
    samples = [sensors()]
    busy_samples = []
    deadline = start + args.seconds
    while True:
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            break
        time.sleep(min(2, remaining))
        current = cpu_times()
        delta = [new - old for old, new in zip(previous_cpu, current)]
        total = sum(delta)
        if total > 0:
            busy_samples.append(round(100 * (total - delta[3] - delta[4]) / total, 2))
        previous_cpu = current
        samples.append(sensors())
    final_processes = processes()
    elapsed = time.monotonic() - start
    final_swap = swap_counters()
    delta = [new - old for old, new in zip(first_cpu, previous_cpu)]
    total = sum(delta)
    hz = os.sysconf('SC_CLK_TCK')
    top_cpu = []
    for pid, process in final_processes.items():
        old = first_processes.get(pid)
        if old and old['start'] == process['start'] and pid != os.getpid():
            top_cpu.append({
                "pid": pid, "name": process['name'], "rss_gib": process['rss_gib'],
                "cpu_pct_one_logical_cpu": round(100 * (process['ticks'] - old['ticks']) / hz / elapsed, 2),
            })

    sensor_summary = []
    for key in sorted(set().union(*(sample.keys() for sample in samples))):
        observed = [sample[key] for sample in samples if key in sample]
        values = [entry['value'] for entry in observed]
        latest = dict(observed[-1])
        latest.pop('value')
        sensor_summary.append({"sensor": key, **latest, "samples": len(values),
                               "min": round(min(values), 2), "max": round(max(values), 2),
                               "mean": round(sum(values) / len(values), 2),
                               "last": round(values[-1], 2)})

    report = {
        "sample_started_at": started_at,
        "sample_ended_at": datetime.now().astimezone().isoformat(timespec='seconds'),
        "sample_seconds": round(elapsed, 2),
        "host": platform.node(), "kernel": platform.release(),
        "hardware": {key: read('/sys/class/dmi/id/' + key)
                     for key in ('sys_vendor', 'product_name')},
        "uptime_seconds": float(Path('/proc/uptime').read_text().split()[0]),
        "logical_cpus": os.cpu_count(), "load_average": os.getloadavg(),
        "cpu": {"busy_pct": round(100 * (total - delta[3] - delta[4]) / total, 2) if total else None,
                "iowait_pct": round(100 * delta[4] / total, 2) if total else None,
                "steal_pct": round(100 * delta[7] / total, 2) if total else None,
                "busy_pct_samples": busy_samples},
        "memory": memory(),
        "swap_pages_during_sample": {key: final_swap[key] - first_swap[key] for key in first_swap},
        "pressure": {key: read('/proc/pressure/' + key) for key in ('cpu', 'memory', 'io')},
        "top_cpu": sorted(top_cpu, key=lambda p: p['cpu_pct_one_logical_cpu'], reverse=True)[:10],
        "top_memory": sorted(
            [{"pid": pid, "name": p['name'], "rss_gib": p['rss_gib']}
             for pid, p in final_processes.items() if pid != os.getpid()],
            key=lambda p: p['rss_gib'], reverse=True)[:10],
        "sensors": sensor_summary,
        "notes": ["Power sensors describe components, not whole-system wall power.",
                  "No SMART self-test or privileged commands are run.",
                  "Missing sensors/commands are not evidence of healthy hardware.",
                  "Process RSS can double-count shared memory."],
    }
    if not any(sensor['unit'] == 'C' for sensor in sensor_summary):
        report['notes'].append('No readable hwmon temperature sensors were found.')
    if not any(sensor['unit'] == 'RPM' for sensor in sensor_summary):
        report['notes'].append('Fan RPM is unavailable.')

    report['commands'] = {
        "cpu_details": command('lscpu', '-J'),
        "disk_space": command('df', '-h', '-l'),
        "disk_devices": command('lsblk', '-d', '-o', 'NAME,MODEL,SIZE,ROTA,TYPE'),
        "failed_system_units": command('systemctl', '--failed', '--no-pager', '--plain'),
        "failed_user_units": command('systemctl', '--user', '--failed', '--no-pager', '--plain'),
        "kernel_errors_this_boot": command('journalctl', '-k', '-b', '-p', '0..3', '--no-pager', '-n', '80'),
        "kernel_health_events": command(
            'journalctl', '-k', '-b', '--no-pager', '-n', '80', '--grep',
            '(?i)out of memory|oom-kill|killed process|throttl|overheat|critical temperature|'
            'hardware error|machine check|I/O error|nvme.*(error|reset|timeout)|'
            'fan.*fail|thermal.*(trip|critical)',
        ),
        "errors_last_hour": command('journalctl', '-b', '--since', '1 hour ago', '-p', '0..3', '--no-pager', '-n', '50'),
    }
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
