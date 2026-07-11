# ☸️ Track 3 — Kubernetes Security

Securing the orchestrator end-to-end, CKS-aligned. Kubernetes adds a control plane,
a network fabric, identity, and policy on top of container runtimes — each a new
attack surface. This track assumes you've done Linux + Docker.

## The 4 C's of Cloud-Native Security (the framing for everything here)
```
   ┌─────────────────────────────────────────────────────┐
   │  CLOUD  (or datacenter — IAM, VPC, host, metadata)   │
   │  ┌───────────────────────────────────────────────┐  │
   │  │  CLUSTER  (API server, etcd, RBAC, admission)  │  │
   │  │  ┌─────────────────────────────────────────┐  │  │
   │  │  │  CONTAINER (image, runtime, caps, seccomp)│ │  │
   │  │  │  ┌───────────────────────────────────┐   │  │  │
   │  │  │  │  CODE (app, deps, secrets, TLS)   │   │  │  │
   │  │  │  └───────────────────────────────────┘   │  │  │
   │  │  └─────────────────────────────────────────┘  │  │
   │  └───────────────────────────────────────────────┘  │
   └─────────────────────────────────────────────────────┘
   Weakness at an outer layer defeats hardening at inner layers.
```

## Modules by phase
**A. Cluster & Nodes** — [01 Control Plane](01-control-plane-security/) · [02 Nodes](02-node-security/)
**B. Identity & Access** — [03 AuthN](03-authentication/) · [04 RBAC](04-authorization-rbac/) · [05 Admission](05-admission-controllers/) · [06 Pod Security Admission](06-pod-security-admission/)
**C. Workload Isolation** — [07 SecurityContext](07-security-contexts/) · [08 Seccomp](08-seccomp/) · [09 AppArmor/SELinux](09-apparmor-selinux-in-k8s/) · [10 Capabilities](10-linux-capabilities/)
**D. Secrets & Data** — [11 ServiceAccounts](11-service-accounts/) · [12 Secrets](12-secrets-management/) · [13 Encryption at Rest](13-encryption-at-rest/) · [14 Vault/ESO](14-external-secrets-and-vault/)
**E. Network** — [15 NetworkPolicy](15-network-policies/) · [16 Istio/mTLS](16-istio-and-mtls/)
**F. Supply Chain** — [17 Image Signing](17-image-security-and-signing-cosign-sigstore/) · [18 SBOM/SLSA](18-sbom-slsa-supply-chain/)
**G. Runtime & Ops** — [19 Falco/eBPF](19-runtime-security-falco-ebpf/) · [20 Audit](20-audit-logging/) · [21 CIS/NSA Hardening](21-cluster-hardening-cis-nsa/) · [22 kube-bench/hunter/kubescape](22-kube-bench-hunter-kubescape/)
**H. Tenancy, Continuity, Governance** — [23 Multi-Tenancy](23-multi-tenancy/) · [24 Backup/DR](24-backup-and-disaster-recovery/) · [25 Compliance](25-compliance/) · [26 IR & Threat Modeling](26-incident-response-and-threat-modeling/)

> Start with [01 — Control Plane Security](01-control-plane-security/).
