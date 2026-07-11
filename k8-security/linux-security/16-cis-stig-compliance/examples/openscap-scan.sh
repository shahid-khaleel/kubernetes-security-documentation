#!/usr/bin/env bash
# OpenSCAP evaluation against a CIS/STIG profile + HTML report + remediation.
set -euo pipefail
sudo yum install -y openscap-scanner scap-security-guide 2>/dev/null || \
  sudo apt-get install -y openscap-scanner ssg-debderived
PROFILE="xccdf_org.ssgproject.content_profile_cis"
DS=$(ls /usr/share/xml/scap/ssg/content/ssg-*-ds.xml | head -1)
sudo oscap xccdf eval --profile "$PROFILE" \
  --results scan-results.xml --report scan-report.html "$DS" || true
echo "Open scan-report.html. Generate remediation: oscap xccdf generate fix --profile $PROFILE $DS"
