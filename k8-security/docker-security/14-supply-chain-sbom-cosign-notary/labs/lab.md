# Lab — Sign + SBOM + Verify
1. `examples/sign-and-sbom.sh <image>` → sign (keyless) + attach CycloneDX SBOM.
2. `cosign verify` and `cosign verify-attestation` → confirm signature + provenance.
3. Tamper (re-push a different image to the tag) → verification fails.
**Deliverable:** successful verify, then a failed verify after tampering.
