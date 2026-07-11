# 17 — Image Security & Signing (Cosign / Sigstore)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** SLSA, NIST SR/SI-7, PCI 6.3, NSA/CISA

**Objectives:** sign images (keyless), verify signatures at admission, restrict registries, enforce digests.

## Concept
Admission-time image security ensures the cluster only runs **trusted** images. **Cosign/Sigstore**
sign images (keyless: short-lived Fulcio cert from OIDC identity + Rekor transparency log).
An **admission policy** (Kyverno `verifyImages` / Gatekeeper / Connaisseur) then **rejects any
pod whose image isn't signed by an approved identity** — closing the gap between "scanned in CI"
and "actually running." Also restrict to approved registries and require **digests** (not mutable tags).

## Risks & attacks
- Running tampered/backdoored/typosquatted images; mutable tags swapped after scan (TOCTOU);
  images from untrusted registries (T1610/T1195). Unsigned base images.

## Best practices & hardening
- Sign every build ([examples/cosign-sign-verify.sh](examples/cosign-sign-verify.sh)); **enforce verification
  at admission** ([examples/kyverno-verify-images.yaml](examples/kyverno-verify-images.yaml)).
- Restrict registries (module 05), require image **digests**, block `:latest`, verify SBOM attestations (module 18).

## Compliance
| SLSA | NIST SR-3/4/11, SI-7 | ISO A.8.30 | PCI 6.3 | NSA/CISA |
|---|---|---|---|---|
| provenance | supply chain/integrity | outsourced dev | secure dev | signed images |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What is keyless signing? Where is verification enforced? Why require digests? **Interview —** *B:* Why sign images? *I:* Enforce signed-only at admission. *A:* End-to-end trust from build to admission. **Scenario:** unsigned image ran in prod → deploy verifyImages enforce, sign all builds in CI, block unapproved registries, require digests.
