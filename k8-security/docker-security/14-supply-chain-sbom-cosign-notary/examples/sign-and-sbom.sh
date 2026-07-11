#!/usr/bin/env bash
set -euo pipefail
IMG="${1:?image}"
syft "$IMG" -o cyclonedx-json > sbom.json          # SBOM
cosign sign --yes "$IMG"                             # sign (keyless)
cosign attest --yes --type cyclonedx --predicate sbom.json "$IMG"   # attach SBOM attestation
cosign verify "$IMG" --certificate-identity-regexp '.*' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
