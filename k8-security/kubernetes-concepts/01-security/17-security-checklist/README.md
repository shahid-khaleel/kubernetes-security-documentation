# Kubernetes Security Checklist (Cluster/Platform)

A one-page, actionable checklist mapping to this curriculum. Use for reviews/audits.

## Authentication & Authorization
- [ ] Anonymous auth disabled; OIDC+MFA for humans; bound tokens for workloads → [sec/03](../../../kubernetes-security/03-authentication/)
- [ ] `--authorization-mode=Node,RBAC`; least-privilege RBAC; no cluster-admin on SAs → [sec/04](../../../kubernetes-security/04-authorization-rbac/)
## Workloads
- [ ] PSA `restricted` enforced on app namespaces → [topic 03](../03-pod-security-admission/)
- [ ] Non-root, read-only rootfs, drop ALL caps, seccomp RuntimeDefault → [sec/07](../../../kubernetes-security/07-security-contexts/)
- [ ] `automountServiceAccountToken:false` by default → [sec/11](../../../kubernetes-security/11-service-accounts/)
## Network
- [ ] Default-deny NetworkPolicies + explicit allows → [sec/15](../../../kubernetes-security/15-network-policies/)
- [ ] Pod access to cloud metadata endpoint blocked → [topic 15](../15-api-server-bypass-risks/)
- [ ] mTLS for sensitive east-west traffic → [sec/16](../../../kubernetes-security/16-istio-and-mtls/)
## Data
- [ ] etcd encryption at rest (KMS) + TLS/peer certs → [sec/01](../../../kubernetes-security/01-control-plane-security/),[13](../../../kubernetes-security/13-encryption-at-rest/)
- [ ] Secrets least-privilege + externalized (Vault/CSI) → [sec/12](../../../kubernetes-security/12-secrets-management/),[14](../../../kubernetes-security/14-external-secrets-and-vault/)
## Supply chain
- [ ] Images scanned + signed; admission verifies signatures; approved registries → [sec/17](../../../kubernetes-security/17-image-security-and-signing-cosign-sigstore/)
## Detection & Ops
- [ ] Audit logging on + shipped off-cluster → [sec/20](../../../kubernetes-security/20-audit-logging/)
- [ ] Runtime detection (Falco/eBPF) → [sec/19](../../../kubernetes-security/19-runtime-security-falco-ebpf/)
- [ ] kube-bench/kubescape passing; CIS/NSA hardened → [sec/21](../../../kubernetes-security/21-cluster-hardening-cis-nsa/),[22](../../../kubernetes-security/22-kube-bench-hunter-kubescape/)
- [ ] Backups (etcd+Velero), tested restores, DR plan → [sec/24](../../../kubernetes-security/24-backup-and-disaster-recovery/)
- [ ] IR playbook + threat model → [sec/26](../../../kubernetes-security/26-incident-response-and-threat-modeling/)

Run automated checks: [../../../scripts/k8s-quick-audit.sh](../../../scripts/k8s-quick-audit.sh).
