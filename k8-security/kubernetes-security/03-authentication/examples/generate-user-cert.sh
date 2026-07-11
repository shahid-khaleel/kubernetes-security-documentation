#!/usr/bin/env bash
# Create a client cert identity 'dev-alice' in group 'developers' (X.509 authN).
set -euo pipefail
openssl genrsa -out alice.key 4096
openssl req -new -key alice.key -out alice.csr -subj "/CN=dev-alice/O=developers"
# Sign with the cluster CA (kubeadm: /etc/kubernetes/pki/ca.{crt,key})
openssl x509 -req -in alice.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out alice.crt -days 90 -sha256
kubectl config set-credentials dev-alice --client-certificate=alice.crt --client-key=alice.key
echo "CN=dev-alice O=developers -> username 'dev-alice', group 'developers' for RBAC"
