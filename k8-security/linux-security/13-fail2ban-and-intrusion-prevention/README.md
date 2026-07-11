# 13 — Fail2Ban & Intrusion Prevention

> **Track:** Linux Security · **Level:** 🟡 · **Refs:** CIS, PCI 10.6, NIST SI-4

**Objectives:** deploy jails/filters; auto-ban brute-forcers; integrate with firewall; avoid self-lockout.

## Concept
**Fail2Ban** watches log files (or journald) with regex **filters**, and when an IP crosses a
threshold (`maxretry` in `findtime`) it triggers an **action** (usually a firewall ban for
`bantime`) via **jails**. It turns detection into automated response for brute-force against
SSH, web logins, mail, etc. `recidive` jail escalates bans for repeat offenders.

## Risks & attacks it addresses (and its limits)
- Online brute force / credential stuffing (T1110) against exposed services.
- Limits: log-based (encrypted/log-less attacks evade it), can be a DoS vector via spoofed
  logs → **allowlist your own admin IPs** to avoid self-lockout; combine with key-only auth.

## Best practices & hardening
- Enable `sshd` + `recidive` jails; sane thresholds; `ignoreip` for admin ranges/bastion.
- Use `backend=systemd`; persist bans; alert on bans. See [examples/jail.local](examples/jail.local).
- Defense-in-depth: fail2ban + key-only SSH (module 03) + MFA (05) + firewall (11).

## Compliance
| PCI 10.6 | ISO A.8.16 | NIST SI-4 | SOC2 CC7.2 |
|---|---|---|---|
| monitor & respond | monitoring | system monitoring | detection |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** jail vs filter vs action? What is `findtime`? How avoid locking yourself out? **Interview —** *B:* What does fail2ban do? *I:* Configure an sshd jail + recidive. *A:* Limitations of log-based IPS and what to layer on top. **Scenario:** SSH brute-force flood → deploy fail2ban with allowlist, verify bans, then reduce exposure (key-only, source allowlist) so bans become rare.
