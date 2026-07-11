#!/usr/bin/env bash
# Keyless signing + verification with cosign/sigstore (OIDC identity, no long-lived keys).
set -euo pipefail
IMG="registry.corp.example.com/app:1.4.2"
cosign sign --yes "$IMG"                                   # keyless (Fulcio/Rekor)
cosign verify \
  --certificate-identity-regexp='https://github.com/corp/.*' \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  "$IMG"
