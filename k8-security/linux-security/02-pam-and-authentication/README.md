# 02 — PAM & Authentication

> **Track:** Linux Security · **Level:** 🟡 · **Refs:** CIS 5.3/5.4, NIST IA-2/IA-5

**Objectives:** understand the PAM stack; enforce password policy + account lockout; reason about `nsswitch`/auth sources.

## Concept (what/why/how)
**PAM (Pluggable Authentication Modules)** is the framework that *every* login path on Linux
(login, sshd, sudo, su, cron, display managers) calls to authenticate and enforce policy —
instead of each program implementing its own. Config lives in `/etc/pam.d/<service>`, each
line = `type control module args`. The four **types**: `auth` (prove identity), `account`
(is the account allowed/expired?), `password` (change credentials), `session` (setup/teardown).
**Controls** (`required`, `requisite`, `sufficient`, `optional`, or `[success=... default=...]`)
decide stack flow. `nsswitch.conf` picks *where* users come from (files, LDAP, SSSD).

## Security risks & attacks
- Weak/absent password policy → brute-force & credential stuffing (T1110).
- No lockout → unlimited online guessing. Misordered `sufficient` → auth bypass.
- `pam_permit`/misconfig can silently allow anyone. LDAP/SSSD trust issues → auth spoofing.

## Best practices & hardening
- `pam_pwquality` (minlen 14, 4 classes) — see [examples/pwquality.conf](examples/pwquality.conf).
- `pam_faillock` lockout after 5 fails — see [examples/pam-faillock.conf](examples/pam-faillock.conf).
- `pam_pwhistory` (remember 5), `pam_unix ... sha512 rounds=65536`, `nullok` removed.
- Layer MFA via PAM (module 05). Test changes in a second session — a broken PAM stack locks you out.

## Compliance
| CIS 5.4 | PCI 8.3 | ISO A.5.17 | NIST IA-5 | HIPAA 164.308(a)(5) |
|---|---|---|---|---|
| pw policy/lockout | strong authN | secret mgmt | authenticator mgmt | password mgmt |

## Lab & examples
See [labs/lab.md](labs/lab.md), [examples/](examples/). **Quiz:** What are the 4 PAM types?
Why can a `sufficient` line create a bypass? How does `faillock` differ from `tally2`?
**Interview —** *B:* What is PAM? *I:* Explain control flags with an example stack.
*A:* Design an MFA-enforcing PAM stack that fails safe and survives IdP outage.
**Scenario:** brute-force alerts on SSH → deploy faillock + fail2ban (module 13) + key-only auth (module 03), then prove lockout works.
