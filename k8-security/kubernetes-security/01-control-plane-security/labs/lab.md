# Lab — Control Plane Hardening & etcd Encryption
> kind/kubeadm cluster. See ../../../labs/SAFETY.md
1. Inspect the API server static pod flags:
   `sudo grep -E 'anonymous-auth|authorization-mode|audit|encryption' /etc/kubernetes/manifests/kube-apiserver.yaml`
2. Enable Secret encryption at rest: copy `examples/etcd-encryption-config.yaml`, add
   `--encryption-provider-config`, restart kube-apiserver, then re-encrypt existing secrets:
   `kubectl get secrets -A -o json | kubectl replace -f -`
3. Verify in etcd it's ciphertext (see module 13 `verify-encryption.sh`).
4. Run kube-bench (module 22) and fix any control-plane FAILs.
**Deliverable:** before/after kube-bench score + etcd hexdump showing `k8s:enc:` prefix.
