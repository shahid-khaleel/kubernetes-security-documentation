# 14 — Host Audit, AV & Rootkit Detection (Lynis / ClamAV / rkhunter / chkrootkit / AIDE)

> **Track:** Linux Security · **Level:** 🟡 · **Refs:** CIS, PCI 5.x/11.5, NIST RA-5/SI-3/SI-7

**Objectives:** run host hardening audits; scan for malware/rootkits; establish file-integrity monitoring (FIM).

## Concept
A toolbox for **detection**: **Lynis** audits host hardening and gives a score + suggestions;
**ClamAV** scans for malware; **rkhunter/chkrootkit** detect known rootkits/backdoors and
suspicious system changes; **AIDE/Tripwire** provide **FIM** — a cryptographic baseline of
critical files, alerting on any change (the strongest signal of tampering/persistence).

## Risks & attacks these surface
- Rootkits/backdoors, unexpected SUID, modified system binaries (T1014/T1554).
- Malware dropped in user/temp dirs. Config/permission drift. Cron/systemd persistence.

## Best practices & hardening
- Schedule Lynis + rkhunter + AIDE checks; alert on deltas. Keep AV signatures fresh.
- **Baseline AIDE on a known-good image**, store the DB read-only/off-host (attacker can edit it).
- Treat findings as leads, not proof; correlate with auditd. See [examples/run-audits.sh](examples/run-audits.sh).

## Compliance
| PCI 5.x/11.5 | ISO A.8.7/8.8 | NIST RA-5/SI-3/SI-7 | HIPAA 164.308(a)(5) |
|---|---|---|---|
| AV + FIM/change-detect | malware/vuln mgmt | scanning/integrity | protection from malware |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) (EICAR test, AIDE baseline). **Quiz:** What is FIM? Why store the AIDE DB off-host? Lynis output use? **Interview —** *B:* What does rkhunter do? *I:* Set up FIM for /etc + /bin. *A:* Design host detection layered with runtime (eBPF) + SIEM. **Scenario:** rootkit suspected → run rkhunter/chkrootkit, diff AIDE, image the host, hunt persistence, rebuild from golden image.
