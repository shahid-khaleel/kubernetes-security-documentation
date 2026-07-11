# 09 — Image Scanning (Trivy / Grype / Docker Scout / Snyk)

> **Track:** Docker Security · **Level:** 🟡 · **Refs:** PCI 6.x/11.x, NIST RA-5/SI-2

**Objectives:** scan images for CVEs/secrets/misconfig; gate CI; manage false positives & suppressions.

## Concept
Image scanners compare an image's packages (and its config/secrets) against vulnerability
databases to find **known CVEs**, **embedded secrets**, and **misconfigurations**. **Trivy**
(all-in-one, IaC+secrets+SBOM), **Grype** (CVE, pairs with Syft SBOM), **Docker Scout**
(Docker-native), **Snyk** (dev-first). Scanning belongs in **CI (block bad builds)**, in the
**registry (continuous re-scan as new CVEs land)**, and at **admission** (K8s 17).

## Risks it addresses / limits
- Shipping known-vulnerable dependencies/base images (T1190 later exploited). Leaked secrets in images.
- Limits: only *known* CVEs; noisy; unfixable/base CVEs need risk acceptance, not ignoring.

## Best practices & hardening
- Fail CI on **HIGH/CRITICAL fixable** ([examples/scan-ci-gate.sh](examples/scan-ci-gate.sh)); re-scan
  images in the registry over time. Track suppressions with justification+expiry ([.trivyignore](examples/.trivyignore)).
- Fix by updating base/deps (module 08), not by muting. Generate SBOMs (module 14).

## Compliance
| PCI 6.3/11.x | ISO A.8.8 | NIST RA-5/SI-2 | SOC2 CC7.1 |
|---|---|---|---|
| vuln scanning | vuln mgmt | scan/remediate | detection |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Where should scanning run? What does `--ignore-unfixed` do? Why re-scan registries? **Interview —** *B:* What does a scanner find? *I:* Add a CI scan gate. *A:* Registry + CI + admission scanning strategy with SLA/exception mgmt. **Scenario:** critical CVE (e.g. in openssl) drops → registry re-scan finds affected images, patch bases, rebuild, block old digests at admission.
