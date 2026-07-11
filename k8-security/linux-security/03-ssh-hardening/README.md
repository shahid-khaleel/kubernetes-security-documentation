# 03 — SSH Hardening

> **Track:** Linux Security · **Level:** 🟢 · **Refs:** CIS 5.2.x, NIST AC-17/SC-8

**Objectives:** disable password/root login; enforce key + strong crypto; build a bastion model; add SSH certificates.

## 1–5. What / why / how / architecture
SSH is the encrypted remote-admin protocol and the **#1 externally exposed service** on
Linux — so it's the #1 brute-force and credential target. `sshd` reads `/etc/ssh/sshd_config`;
auth methods include password (weak), **public key** (strong), and **SSH certificates**
(scalable — a CA signs short-lived user/host certs, no `authorized_keys` sprawl).
```
 client ──TCP 22──► sshd ──PAM/pubkey──► session
        bastion/jump host ──► internal hosts (no direct internet SSH to prod)
        SSH CA signs user certs (TTL hours) ──► hosts trust the CA, not individual keys
```

## 6–7. Risks & attacks
- Password auth + root login → brute force (T1110), credential stuffing.
- Weak ciphers/MACs/kex → downgrade/MITM. Exposed `:22` to internet → constant scanning.
- Agent/TCP forwarding abuse → pivoting. Stolen private keys (unencrypted) → account takeover.

## 9–10. Best practices & hardening
- `PermitRootLogin no`, `PasswordAuthentication no`, `PubkeyAuthentication yes`, `MaxAuthTries 3`.
- Modern crypto only (curve25519, chacha20/aes-gcm, etm MACs). `AllowGroups sshusers`.
- Disable X11/agent/TCP forwarding unless needed. Bastion + firewall/allowlist source IPs.
- Move to **SSH certificates** at scale; `Match` blocks for per-group policy. Full config:
  [examples/sshd_config.hardened](examples/sshd_config.hardened). Validate with `sshd -t`.

## 11. Compliance
| CIS 5.2 | PCI 2.2/8.x | ISO A.8.20 | NIST AC-17 | SOC2 CC6.6 |
|---|---|---|---|---|
| sshd hardening | secure remote access | network security | remote access | boundary |

## Lab, quiz, interview, scenario
Lab: [labs/lab.md](labs/lab.md) — harden sshd, audit crypto with `nmap ssh2-enum-algos`.
**Quiz:** Why key > password? What does `MaxAuthTries` limit? Purpose of a bastion? SSH cert vs key?
**Interview —** *B:* How to disable root SSH? *I:* Compare key vs cert auth. *A:* Design zero-trust SSH for 10k hosts (CA, short TTL, session recording, MFA).
**Scenario:** Compromised key suspected → rotate, move to certs (auto-expire), enable session logging, restrict source IPs, add MFA (module 05).
