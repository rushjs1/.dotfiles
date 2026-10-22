---
name: health-check
description: Check the current Linux mini PC's CPU, RAM, temperatures, processes, storage, and system errors; assess whether shutdown is warranted and estimate its monthly 24/7 electricity cost in Indianapolis. Use for /health-check or requests for this computer's vitals.
---

# Health check

Give a concise, current assessment of this computer and whether it is reasonable to leave it running. Default the electricity estimate to Indianapolis, Indiana, unless the user specifies another location. Recheck the hardware and readings every time; do not reuse an earlier report as current evidence.

## Collect the vitals

Run the bundled collector from this skill's directory:

```bash
python3 scripts/collect.py --seconds 30
```

It uses Python's standard library and existing Linux tools, samples CPU and sensors every two seconds, and prints JSON. It does not install packages, change settings, or write a report. If the tools runner returns a live session, resume that session to obtain the completed output. On a different operating system, use its native diagnostics and disclose which measurements are unavailable.

Use the output to cover CPU model/core count, sampled utilization and load, RAM used/available, swap and pressure, CPU/GPU/SSD temperatures, top CPU and memory consumers, free disk space, failed services, and recent kernel errors. A process's CPU percentage uses one logical CPU as 100%; whole-machine utilization uses the entire machine as 100%. Process RSS can count shared pages more than once; do not sum it and call that physical RAM usage. The top-CPU list covers processes present at both ends of the sample; short-lived processes may be absent.

Follow up only where the readings leave a material question:

- Inspect logs for a failed service or suspicious kernel event. Distinguish startup messages from recurring runtime failures, and actual hardware faults from lines saying an error decoder was enabled.
- If `smartctl` or `nvme` is already available and the device permits reads, inspect the relevant SSD's health/error counters. Do not start a self-test. Otherwise explicitly say SMART health was unavailable; free space and temperature do not prove SSD health.
- Compare temperatures with credible sensor limits or the CPU manufacturer's specification. Reject implausible limits such as 65,261°C. If no trustworthy limit exists, describe the reading and uncertainty instead of inventing a safe maximum. Missing fan RPM or throttle counters do not prove a fan failure or absence of throttling.
- For an alarming reading, take another short sample to establish whether it persists. Use read-only diagnostics; do not stress-test the machine, kill processes, reboot, shut down, or change power/fan settings unless separately requested.

## Interpret the result

Lead with the verdict: comfortable to leave on, needs attention, or recommend shutting down. Give the measured reason. High CPU or RAM usage alone is not a shutdown reason. Treat sustained temperatures near a verified limit, overheating accompanied by instability, or serious repeated hardware/I/O errors as requiring attention. Advise an orderly shutdown when the evidence warrants it; a request for a health report is not permission to perform one.

Use `MemAvailable` when assessing memory headroom; Linux cache is reclaimable. Consider swap activity, pressure, and OOM events together. Normalize load against logical CPU count and distinguish CPU work from I/O waits. Explain a busy process in terms of total capacity before calling it concerning. Small startup firmware/TPM errors can be follow-up items without implying an immediate thermal hazard.

## Estimate 24/7 electricity cost

Prefer a whole-system wall-power reading from an available meter. Otherwise give a clearly labeled estimate/range appropriate to the identified machine and sampled workload. CPU/GPU/package telemetry, TDP, and the adapter's rated wattage are not wall power. Do not add overlapping CPU/APU/GPU sensor domains. State the basis for the assumed wall-power range and that a plug-in meter is needed to confirm it.

Look up a recent applicable residential rate from the utility's official site. For Indianapolis, assume AES Indiana if the actual supplier is unknown and say so. Start with [AES Indiana rates and tariffs](https://www.aesindiana.com/rates-tariffs) and check the effective date, applicable riders, usage tier, and tax. Use a rounded rate or range when the household tariff is unknown. If browsing is unavailable, label the rate an assumption instead of calling it current. Do not charge the PC the household's existing fixed customer fee; account for a tier-crossing fee only if the household usage is known to cross that threshold.

Use a stated 30-day month: `watts / 1000 × 24 × 30 = kWh`, then `kWh × dollars/kWh = cost`. Exclude monitors/peripherals unless measured or requested. Keep workload, wall-power, and tariff uncertainty visible; a short sample is not a month-long measurement.

## Deliver

Keep the final response short: verdict first, a small vitals table or bullets, only noteworthy processes/errors, and a final monthly cost estimate with wattage, rate, kWh, and a source link. Include the local timestamp and sample duration. Briefly disclose missing temperature/SMART/power readings that limit the conclusion. Acknowledge a bedtime sign-off naturally when present. Keep raw logs, machine identifiers, and process output out of any public repository or PR.
