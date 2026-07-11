#!/usr/bin/env bash
# etcd snapshot + restore (control-plane DR). RPO = snapshot interval.
set -euo pipefail
ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save "/var/backups/etcd-$(date +%F-%H%M).db"
# Verify: etcdctl snapshot status <file>
# Restore: etcdutl snapshot restore <file> --data-dir /var/lib/etcd-restore
