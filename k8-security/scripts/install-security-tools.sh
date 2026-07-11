#!/usr/bin/env bash
# install-security-tools.sh — install the CLI toolchain used across the curriculum.
# Ubuntu/Debian. Idempotent-ish. Review before running.
set -euo pipefail
sudo apt-get update
sudo apt-get install -y curl wget jq git ca-certificates gnupg lsb-release \
  auditd apparmor-utils lynis clamav rkhunter chkrootkit nmap tcpdump openssl uidmap

install_bin(){ sudo install -m0755 "$1" /usr/local/bin/"$2"; rm -f "$1"; }

# trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
# grype + syft
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh  | sudo sh -s -- -b /usr/local/bin
# cosign
curl -sLO https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64 && install_bin cosign-linux-amd64 cosign
# kubescape
curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash
# kubectl + kind (see labs/README.md if missing)
echo "Done. kube-bench/kube-hunter run as k8s Jobs/containers (see K8s module 22)."
