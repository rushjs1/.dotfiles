---
name: health-check
description: Check this Linux PC's vitals, assess whether it needs shutting down, and estimate monthly electricity cost in Indianapolis. Use for /health-check or requests for this computer's health.
---

# Health check

Assess whether this computer needs attention or shutdown. Collect fresh readings each time. Default the electricity estimate to Indianapolis, Indiana.

## Collect the vitals

Run from this skill's directory:

```bash
python3 scripts/collect.py --seconds 30
```

The collector prints JSON with CPU, memory, swap, pressure, temperatures, processes, disk space, failed services, and kernel errors.

Use read-only diagnostics. Do not install tools, stress-test, change settings, stop processes, or shut down unless separately requested.

Interpret the readings with these limits:

- Process CPU percentages use one logical CPU as 100%. Total CPU usage covers the whole machine. Compare load with logical CPU count and check I/O wait. The process list can miss short-lived work.
- Use `MemAvailable` for RAM headroom. Check swap activity, pressure, and out-of-memory events. Do not sum process RSS as physical RAM usage because processes can share pages.
- Compare temperatures with credible sensor limits or manufacturer specifications. Reject implausible limits. Missing fan readings or throttle counters cannot establish fan health or absence of throttling.
- Inspect failed-service logs and suspicious kernel events. Separate startup firmware errors and driver initialization messages from recurring faults.
- Read SSD health counters with `smartctl` or `nvme` if already available and permitted. Do not start a self-test. Otherwise report SMART health as unavailable.

## Interpret the result

Repeat an alarming reading with a short sample. Sustained heat near a verified limit, overheating with instability, or repeated serious hardware errors need attention. High CPU or RAM usage alone does not warrant shutdown. Recommend an orderly shutdown when the evidence supports it.

## Estimate 24/7 electricity cost

Use measured wall power when available. Otherwise estimate a range for the machine and workload, state the basis, and explain that a plug-in meter would confirm it. Component sensors, TDP, and adapter ratings are not wall power. Do not add overlapping sensor readings.

Check the utility's official residential rate, effective date, riders, usage tier, and tax. If the Indianapolis supplier is unknown, assume [AES Indiana](https://www.aesindiana.com/rates-tariffs) and say so. If the actual tariff or current rates are unavailable, label the rate as an estimate. Exclude the household's existing fixed fee. Include a fee increase only if known usage crosses its threshold.

Calculate a 30-day month with `watts / 1000 × 24 × 30 = kWh`, then `kWh × dollars/kWh = cost`. Exclude unmeasured monitors and peripherals. State that the estimate assumes the sampled workload continues all month.

## Deliver

Lead with the shutdown verdict and measured reason. Give a compact vitals table, noteworthy processes or errors, and the local timestamp and sample duration. Disclose missing readings that limit the conclusion. End with monthly cost, assumed watts, rate, kWh, and a source link. Keep raw logs, process output, and machine identifiers out of public repositories and PRs.
