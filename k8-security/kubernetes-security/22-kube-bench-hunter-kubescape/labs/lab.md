# Lab — Automated Posture Scanning
1. `examples/run-scanners.sh` → kube-bench (CIS) + kubescape (NSA/MITRE).
2. Triage the top 5 findings; fix 2 and re-scan.
3. (Lab-only) run kube-hunter in remote mode against your kind API IP.
**Deliverable:** scanner reports + a fixed-findings diff.
