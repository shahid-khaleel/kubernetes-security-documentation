# 04 — sudo & Privilege Escalation

> **Track:** Linux Security · **Level:** 🟡 · **Refs:** CIS 5.3, NIST AC-6

**Objectives:** write least-privilege sudoers; avoid GTFOBins shell-escapes; log & audit privileged commands.

## Concept
`sudo` grants specific users/groups the ability to run specific commands as another user
(usually root) with per-command policy in `/etc/sudoers` (+ `/etc/sudoers.d/`), always edited
via `visudo` (syntax-checked). It's the controlled alternative to sharing the root password
and the primary **audited** privilege-elevation path.

## Risks & attacks (this is a top local-privesc area)
- `NOPASSWD: ALL` or `%group ALL=(ALL) ALL` → effectively root for that group.
- **GTFOBins:** allowing `vi`, `less`, `find`, `env`, `awk`, `python`, `tar` via sudo lets a
  user shell-escape to root (`sudo vi` → `:!/bin/sh`). Writable sudo-run scripts → hijack.
- `sudo` CVEs (e.g. CVE-2021-3156 Baron Samedit heap overflow) → patch promptly.

## Best practices & hardening
- Least privilege: name exact commands, no wildcards that enable shell escape.
- `Defaults use_pty`, `logfile=/var/log/sudo.log`, `requiretty`, `passwd_timeout`.
- Never grant editors/interpreters via sudo. Prefer `systemctl`-scoped actions. Patch sudo.
- Example: [examples/sudoers-least-privilege.conf](examples/sudoers-least-privilege.conf).

## Compliance
| CIS 5.3 | PCI 7.x | ISO A.8.2 | NIST AC-6(9) | SOC2 CC6.3 |
|---|---|---|---|---|
| sudo config/log | least privilege | privileged access | privileged fn logging | least privilege |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) — reproduce a GTFOBins escape, then fix. **Quiz:** Why is
`sudo find` dangerous? What does `use_pty` add? Why `visudo`? **Interview —** *B:* sudo vs su?
*I:* Design least-privilege sudo for an ops team. *A:* How do you detect/prevent GTFOBins escapes fleet-wide + centralize sudo logs? **Scenario:** user escalated via `sudo vim` → tighten rules, audit all sudoers for GTFOBins commands, ship `sudo.log` to SIEM, alert on shell-spawn from sudo.
