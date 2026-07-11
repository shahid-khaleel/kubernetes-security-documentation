#!/usr/bin/env bash
# Automated cluster posture scanning — CIS + NSA/MITRE.
set -euo pipefail
echo "== kube-bench (CIS Benchmark) =="
kubectl apply -f https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml
kubectl wait --for=condition=complete job/kube-bench --timeout=120s
kubectl logs job/kube-bench

echo "== kubescape (NSA + MITRE frameworks) =="
kubescape scan framework nsa --format json --output kubescape-nsa.json

echo "== kube-hunter (active recon — lab only!) =="
# docker run -it --rm --network host aquasec/kube-hunter --remote <API_IP>
echo "Run kube-hunter only against clusters you own."
