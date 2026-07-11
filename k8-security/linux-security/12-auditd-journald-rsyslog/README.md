# 12 — auditd, journald & rsyslog (Audit + Logging)

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS 4.1.x, PCI 10.x, NIST AU-2/AU-6/AU-9

**Objectives:** write audit rules for high-value events; forward logs off-host (tamper-evidence); separate audit from ops logs.

## Concept
**auditd** is the kernel-integrated audit subsystem — it records **who did what to what**
(syscalls, file watches, command execution) independently of applications, essential for
forensics and compliance. **journald** (systemd) is the structured local log; **rsyslog**
forwards/filters logs to central/remote collectors. The security goal: capture privileged
and sensitive-file activity, and **ship it off the host** so an attacker with root can't
erase the evidence (tamper-evidence / WORM).

## Risks & attacks
- No auditing → no forensics; attacker actions invisible (T1070 log deletion).
- Local-only logs → root wipes them. Missing watches on `/etc/passwd`,`sudoers`,`ssh`.
- Audit buffer too small → lost events; misconfigured rules → noise drowns signal.

## Best practices & hardening
- Load CIS audit rules ([examples/audit.rules](examples/audit.rules)); watch identity/priv/
  time/module events; `-e 2` (immutable) at end. Size buffers (`-b`).
- **Forward** to remote rsyslog/SIEM over TLS; use append-only/WORM storage. Time-sync (NTP).
- Separate audit log retention (PCI ≥1yr, HIPAA ≥6yr). Review/alert, don't just collect.

## Compliance
| CIS 4.1 | PCI 10.x | ISO A.8.15 | NIST AU-2/6/9 | HIPAA 164.312(b) |
|---|---|---|---|---|
| auditd rules | log & monitor | logging | audit/protect logs | audit controls |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** auditd vs syslog? What does `-w /etc/shadow -p wa` do? Why forward logs? What is `-e 2`? **Interview —** *B:* Why audit? *I:* Write rules to catch privesc + file tampering. *A:* Tamper-evident logging pipeline for PCI. **Scenario:** suspected breach, local logs cleared → recover from remote SIEM, use auditd trail to reconstruct timeline, harden with immutable + remote-first logging.
