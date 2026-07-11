# Lab — SBOM Generation & Attestation
1. `examples/generate-and-attest-sbom.sh` → produce SPDX SBOM, attach as signed attestation.
2. `cosign verify-attestation ...` to validate provenance.
3. Diff SBOMs across two builds to catch a dependency swap.
**Deliverable:** verified SBOM attestation + a build-to-build dependency diff.
