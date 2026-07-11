#!/usr/bin/env bash
# Generate an SBOM and attach it as a signed attestation to the image.
set -euo pipefail
IMG="registry.corp.example.com/app:1.4.2"
syft "$IMG" -o spdx-json > sbom.spdx.json          # or cyclonedx-json
cosign attest --yes --predicate sbom.spdx.json --type spdxjson "$IMG"
# Verify at deploy time:
cosign verify-attestation --type spdxjson \
  --certificate-identity-regexp='.*' \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com "$IMG"
