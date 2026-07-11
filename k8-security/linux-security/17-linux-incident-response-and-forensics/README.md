# 17 — Linux Incident Response & Forensics

> **Track:** Linux Security · **Level:** ⚫ · **Refs:** PCI 12.10, ISO A.5.24-27, NIST IR-4, SANS

**Objectives:** run live triage; respect order of volatility; image memory/disk; build a timeline; hunt persistence/IOCs; preserve chain of custody.

## 1–5. Concept & process
IR is the disciplined process — **Prepare → Detect → Contain → Eradicate → Recover →
Lessons Learned** (NIST 800-61). Forensics preserves and analyzes evidence to determine
*what happened*. Golden rule: **order of volatility** — capture the most ephemeral first
(RAM → network state → running processes → disk → backups) and **don't power off** before
memory capture. Maintain **chain of custody** (hashes, timestamps, who touched what).
```
 Detect ─► Triage (live: procs, net, open files, recent files, SUID, cron/systemd)
        ─► Contain (isolate: firewall/cordon, don't destroy) ─► Image RAM (avml/LiME) & disk (dd/dc3dd)
        ─► Analyze (timeline, IOCs, logs) ─► Eradicate ─► Recover from golden ─► RCA
```

## 6–7. What you hunt / common attacker footprints
- Persistence: cron, systemd units/timers, `~/.bashrc`, SSH `authorized_keys`, LD_PRELOAD,
  planted **SUID** shells, kernel modules. Recently modified files, unexpected listeners,
  reverse shells, cleared logs (T1070), new users, modified binaries.

## 9–10. Best practices & procedures
- Prepare **before** you need it: runbooks, a triage script, offline tooling, log-forwarding
  (so evidence survives). Practice with tabletop + labs.
- Collect to **read-only/external** media; hash everything. See [examples/live-triage.sh](examples/live-triage.sh).
- Contain without tipping off / destroying evidence; rotate all exposed creds; rebuild, don't clean.

## 11. Compliance
| PCI 12.10 | ISO A.5.24-27 | NIST IR-4/5/6/8 | HIPAA 164.308(a)(6) | GDPR Art.33/34 |
|---|---|---|---|---|
| IR plan/test | incident mgmt | IR handling | response procedures | breach notification (72h) |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Order of volatility? Why not power off first? What is chain of custody? Name 3 persistence spots. **Interview —** *B:* IR phases? *I:* Triage a suspected-compromised host step by step. *A:* Run an IR for a multi-host breach incl. forensics + regulator notification. **Scenario:** SIEM flags reverse shell + new SUID on a prod host → contain (isolate), capture RAM+disk, triage script, find cron persistence + entry vector, rotate creds, rebuild from golden, RCA mapped to MITRE + 72h GDPR clock.
