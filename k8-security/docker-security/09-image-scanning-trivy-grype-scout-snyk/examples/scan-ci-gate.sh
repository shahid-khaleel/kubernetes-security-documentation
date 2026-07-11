#!/usr/bin/env bash
# CI gate: fail the build on HIGH/CRITICAL fixable CVEs, secrets, or misconfigs.
set -euo pipefail
IMG="${1:?usage: scan-ci-gate.sh <image>}"
trivy image --scanners vuln,secret,misconfig \
  --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 "$IMG"
# Alternatives: grype "$IMG" --fail-on high  |  docker scout cves "$IMG"  |  snyk container test "$IMG"
