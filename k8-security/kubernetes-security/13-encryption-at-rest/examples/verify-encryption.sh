#!/usr/bin/env bash
# Prove a secret is encrypted in etcd (should NOT be plaintext).
set -euo pipefail
kubectl create secret generic enc-test --from-literal=k=topsecret -n default || true
sudo ETCDCTL_API=3 etcdctl \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  get /registry/secrets/default/enc-test | hexdump -C | head
echo ">> Expect to see 'k8s:enc:kms:' or 'k8s:enc:aescbc:' prefix, NOT 'topsecret'."
