# 18 — SBOM, SLSA & Supply-Chain Security

> **Track:** Kubernetes Security · **Level:** ⚫ · **Refs:** SLSA, NIST SSDF/SR, EO 14028

**Objectives:** generate/attest SBOMs; understand SLSA levels & build provenance; use in-toto; respond to CVEs via SBOM.

## Concept
Supply-chain security secures **how software is built and delivered**, not just the running
artifact. **SBOM** (Syft → SPDX/CycloneDX) = component inventory for vuln response/compliance.
**SLSA** (levels 1–4) grades **build integrity** — from "scripted build" to "hermetic,
reproducible, tamper-resistant with signed provenance." **Provenance/in-toto** attestations
(signed via Cosign) prove *what built this, from what source, how* — verified at deploy.

## Risks & attacks
- Compromised build systems (SolarWinds), dependency confusion, poisoned dependencies,
  tampered artifacts between build and deploy (T1195). Without an SBOM you **can't answer
  "are we affected by CVE-X?"** quickly.

## Best practices & hardening
- Generate + **attest** SBOMs ([examples/generate-and-attest-sbom.sh](examples/generate-and-attest-sbom.sh)); verify
  provenance at admission (with module 17). Target **SLSA L3**: isolated, provenance-signed builds.
- Store SBOMs for fast CVE triage; diff SBOMs to catch unexpected dependency changes.

## Compliance
| SLSA | NIST SSDF/SR-3/4/11 | ISO A.8.30 | EO 14028 | PCI 6.3 |
|---|---|---|---|---|
| build levels | supply chain | outsourced dev | SBOM mandate | secure dev |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What is an SBOM for? What does SLSA measure? What is provenance? **Interview —** *B:* Why SBOMs? *I:* Generate + attest an SBOM. *A:* Reach SLSA L3 + verify provenance at deploy. **Scenario:** new critical CVE in a common lib → query SBOMs to find every affected image in minutes, patch/rebuild/resign, verify provenance.
