# Lab — Sign & Verify Images (Cosign) + Admission Enforcement
1. Sign a test image with `examples/cosign-sign-verify.sh` (keyless).
2. Apply Kyverno `examples/kyverno-verify-images.yaml`.
3. Deploy the signed image → allowed. Deploy an unsigned/other-identity image → BLOCKED.
**Deliverable:** admission allow (signed) vs deny (unsigned).
