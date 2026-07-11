# 14 — Supply Chain: SBOM, Cosign & Notary

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** SLSA, NIST SSDF/SR, EO 14028

**Objectives:** sign images (keyless), generate/attest SBOMs, verify provenance, enforce at deploy.

## Concept
Supply-chain security answers "**is this image what we built, unmodified, and what's in it?**"
**Signing** (Cosign/Sigstore — keyless via short-lived OIDC certs + Rekor transparency log;
or Notary/Notation) proves origin & integrity. **SBOM** (Syft → SPDX/CycloneDX) inventories
components for vuln response & compliance. **Attestations** bind SBOM/provenance to the image.
Enforcement happens at **admission** (only run signed images — K8s 17).

## Risks & attacks
- Tampered/backdoored images, typosquatting, registry compromise, dependency confusion
  (SolarWinds-class). Unknown contents → can't respond to a new CVE (no SBOM).

## Best practices & hardening
- Sign every build + attach SBOM attestation ([examples/sign-and-sbom.sh](examples/sign-and-sbom.sh)).
  **Verify** before deploy; pin by digest. Aim for **SLSA** build provenance (module 18).
- Protect the signing identity (keyless/OIDC + policy). Keep SBOMs for vuln triage.

## Compliance
| SLSA | NIST SSDF/SR-3/4/11 | ISO A.8.30 | EO 14028 | PCI 6.3 |
|---|---|---|---|---|
| build integrity | supply chain | outsourced dev | SBOM/provenance | secure dev |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What is keyless signing? Why an SBOM? What is Rekor? **Interview —** *B:* Why sign images? *I:* Sign + verify + attest an image. *A:* End-to-end supply-chain integrity to SLSA L3 + admission enforcement. **Scenario:** registry breach suspected → verify signatures (unsigned/tampered fail), use SBOMs to find affected components, rebuild+resign, enforce signature verification at admission.
