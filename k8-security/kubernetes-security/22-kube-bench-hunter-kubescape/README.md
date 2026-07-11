# 22 — kube-bench / kube-hunter / Kubescape (Posture Scanning)

> **Track:** Kubernetes Security · **Level:** 🟡 · **Refs:** CIS K8s, NSA/CISA, MITRE ATT&CK

**Objectives:** automate CIS benchmarking (kube-bench), active pen-testing (kube-hunter), and framework posture (kubescape).

## Concept
The tooling that **measures** the hardening from module 21. **kube-bench** checks a cluster
against the **CIS Benchmark** and reports PASS/FAIL/WARN with remediation. **kube-hunter**
actively probes a cluster's attack surface (recon/exploit — **lab/authorized use only**).
**Kubescape** scans against **NSA, MITRE ATT&CK, and CIS** frameworks, visualizes RBAC, and
scans images/YAML — great for CI gating and dashboards.

## Risks it addresses
- Unknown/unmeasured posture; drift; blind spots that manual review misses. Turns "we think
  we're secure" into evidence.

## Best practices & hardening
- Run [examples/run-scanners.sh](examples/run-scanners.sh): kube-bench (CIS) + kubescape (NSA/MITRE);
  triage & fix top findings; re-scan. Integrate into **CI/CD** and schedule; track score trend.
- kube-hunter only against clusters you own (remote mode = active testing). Feed results to compliance (25).

## Compliance
| CIS K8s | NSA/CISA | PCI 11.x | ISO A.8.8 | NIST RA-5 |
|---|---|---|---|---|
| benchmark scan | framework scan | testing | vuln mgmt | vuln scanning |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does kube-bench check? Why is kube-hunter lab-only in remote mode? What frameworks does kubescape cover? **Interview —** *B:* Name three K8s scanners. *I:* Run + interpret kube-bench. *A:* Continuous posture scanning + CI gating strategy. **Scenario:** quarterly audit → run all three, produce a scored report, remediate criticals, embed kube-bench in CI to prevent regressions.
