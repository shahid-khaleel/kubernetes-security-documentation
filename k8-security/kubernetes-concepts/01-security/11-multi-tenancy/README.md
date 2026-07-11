# Multi-tenancy

**What it is.** Running multiple teams/customers on shared cluster infrastructure with
isolation appropriate to the threat model. Models: **namespace-per-tenant** (soft),
**virtual clusters** (vCluster), **cluster-per-tenant** (hard).

**Why it matters.** Soft multi-tenancy shares the **control plane and kernel** — a container
escape or over-broad RBAC crosses tenant boundaries.

**Isolation kit (soft multi-tenancy) — combine ALL of these**
- **RBAC** scoped per namespace ([sec/04](../../../kubernetes-security/04-authorization-rbac/)).
- **NetworkPolicy** default-deny ([sec/15](../../../kubernetes-security/15-network-policies/)).
- **PSA Restricted** ([topic 03](../03-pod-security-admission/)).
- **ResourceQuota + LimitRange** (noisy-neighbor / DoS) ([Policies](../../02-policies/)).
- **Unique SELinux MCS** / AppArmor per tenant ([sec/09](../../../kubernetes-security/09-apparmor-selinux-in-k8s/)).
- For **untrusted** tenants: sandboxed runtime (gVisor/Kata) or separate node pools/clusters.

**Best practices:** pick the model by threat level; template identical per-tenant policy;
ensure no tenant can read another's objects (RBAC) or reach them (NetworkPolicy).
**Cross-links:** deep dive → [security/23](../../../kubernetes-security/23-multi-tenancy/).
