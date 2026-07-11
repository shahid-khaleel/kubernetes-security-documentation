# Lab — CI Scan Gate
1. `examples/scan-ci-gate.sh <image>` — fails on HIGH/CRITICAL fixable CVEs/secrets/misconfigs.
2. Compare trivy vs grype vs docker scout output on the same image.
3. Add a justified suppression in `.trivyignore` and re-run.
**Deliverable:** a failing scan, a fix (bump base image), a passing scan.
