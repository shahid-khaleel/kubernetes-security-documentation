# 11 — Firewalls: iptables / nftables / firewalld

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS 3.5, PCI 1.x, NIST SC-7

**Objectives:** build default-deny stateful rules; understand netfilter/tables/chains; control egress; use zones.

## 1–5. What / why / how / architecture
All three are frontends to the kernel's **netfilter** framework. **iptables** (legacy) and
**nftables** (modern replacement) define **tables → chains → rules**; **firewalld** is a
higher-level daemon with **zones** (public/internal/trusted) and runtime/permanent config.
Stateful **connection tracking (conntrack)** lets you allow established/related traffic and
default-deny new. **Egress filtering** (often forgotten) limits exfiltration and C2.
```
 packet ─► netfilter hooks: PREROUTING─►INPUT/FORWARD─►OUTPUT─►POSTROUTING
   INPUT: policy DROP; accept lo, established/related, 22(ratelimit),80,443; drop rest
```

## 6–7. Risks & attacks
- Default-accept / no egress control → lateral movement + data exfil. Overly broad allows.
- SSH exposed without rate-limit → brute force. Stateless rules → spoofing/scan success.
- Rule ordering bugs (allow above a broad deny). conntrack table exhaustion (DoS).

## 9–10. Best practices & hardening
- **Default-deny inbound**, explicit allowlist, stateful, rate-limit SSH. Control egress.
- Prefer **nftables** on modern systems. Persist rules; document. See [examples/nftables.conf](examples/nftables.conf).
- Log drops (sampled) to detect scanning. Combine host firewall + network/cloud SG (defense-in-depth).

## 11. Compliance
| CIS 3.5 | PCI 1.x | ISO A.8.20/22 | NIST SC-7 | SOC2 CC6.6 |
|---|---|---|---|---|
| firewall config | segmentation | network security | boundary protection | boundary |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What is conntrack? Why default-deny? iptables vs nftables? Why filter egress? **Interview —** *B:* Write a rule allowing only 22/80/443. *I:* Explain stateful vs stateless. *A:* Segment a PCI CDE with host+network firewalls + egress allowlist. **Scenario:** exfil to unknown IP detected → add egress allowlist, log drops, alert on new outbound, verify data path cut.
