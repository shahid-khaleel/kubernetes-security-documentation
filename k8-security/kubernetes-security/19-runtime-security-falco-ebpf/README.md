# 19 — Runtime Security (Falco / eBPF / Tetragon)

> **Track:** Kubernetes Security · **Level:** ⚫ · **Refs:** NIST SI-4, PCI 11.5, MITRE ATT&CK

**Objectives:** detect runtime threats via syscalls/eBPF; write Falco rules; route alerts; understand enforcement (Tetragon).

## Concept
Prevention isn't perfect — **runtime security** detects malicious behavior **in running
containers** by observing **syscalls** (via **eBPF** or a kernel module). **Falco** is the
CNCF standard: rules match suspicious events (shell in a container, write to `/etc`, unexpected
egress, sensitive mounts) and emit alerts. **Tetragon** adds eBPF-based **enforcement** (kill/
block). This is the detective control that catches escapes/lateral movement live.

## Risks it addresses (detects)
- Container escapes, reverse shells, crypto-mining, privilege escalation, credential access,
  data exfil — the post-exploitation activity other controls try to prevent (T1059/T1611/T1610).

## Best practices & hardening
- Deploy Falco (modern eBPF) with tuned rules ([examples/falco-custom-rules.yaml](examples/falco-custom-rules.yaml),
  [examples/falco-values.yaml](examples/falco-values.yaml)); route to SIEM/Slack via falcosidekick.
- Tune to cut noise (allowlist known behaviors); map rules to **MITRE ATT&CK**; feed detections
  into IR (module 26). Consider Tetragon for enforcement on crown-jewel namespaces.

## Compliance
| PCI 11.5 | ISO A.8.16 | NIST SI-4 | SOC2 CC7.2 | HIPAA 164.308(a)(6) |
|---|---|---|---|---|
| change/threat detect | monitoring | system monitoring | detection | response |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does Falco observe? eBPF vs kernel module? Falco vs Tetragon? **Interview —** *B:* What is runtime security? *I:* Write a rule for shell-in-container. *A:* Build a detection→response pipeline mapped to ATT&CK. **Scenario:** Falco fires "shell in container" + "unexpected egress" at 3am → triage, contain (module 26), tune rule, add enforcement, RCA.
