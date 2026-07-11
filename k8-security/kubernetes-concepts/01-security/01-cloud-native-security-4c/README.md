# Cloud Native Security — The 4 C's

**What it is.** A layered model for cloud-native security: **Cloud → Cluster → Container →
Code**. Each layer builds on the one outside it; a weakness in an outer layer can't be fixed
by hardening an inner one.

**Why it matters.** It's the mental map for *where* every control in this curriculum applies,
so you cover the whole attack surface rather than over-investing in one layer.

```
Cloud   : IAM, VPC/subnets, host OS, metadata service, KMS       → provider hardening
Cluster : API server, etcd, RBAC, admission, network policy      → k8s-security/01-26
Container: image (scan/sign), runtime (caps/seccomp/LSM), non-root→ k8s-security/07-19, docker track
Code    : deps, secrets handling, TLS, input validation, SAST    → app security checklist (18)
```

**Best practices**
- Secure outer layers first (cloud IAM least-privilege, block pod access to the cloud
  metadata endpoint — see [API bypass risks](../15-api-server-bypass-risks/)).
- Map each control you deploy to a C; audit for gaps at every layer.

**Cross-links:** [Security Checklist](../17-security-checklist/), whole [security track](../../../kubernetes-security/).
