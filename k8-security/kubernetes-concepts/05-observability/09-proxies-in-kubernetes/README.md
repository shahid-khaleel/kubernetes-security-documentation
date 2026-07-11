# Proxies in Kubernetes

**What it is.** The several proxies in a cluster: **kube-proxy** (implements Service VIPs via
iptables/IPVS/eBPF), the **apiserver proxy** (`kubectl proxy`, `/proxy/` subresources to
pods/services/nodes), **kubelet proxy** paths, and sidecar proxies (mesh Envoy).

**Why it matters (security).** Proxies can be **access paths that bypass expectations**: the
apiserver `pods/proxy`, `services/proxy`, `nodes/proxy` subresources let a user with those RBAC
verbs reach workloads/nodes **through the API** (and may skip NetworkPolicy) — an escalation/
recon vector. `kubectl proxy` exposes the API locally without auth if misused.

**Best practices**
- Restrict RBAC on `*/proxy` subresources (treat as privileged); audit their use.
- Don't leave `kubectl proxy` running/exposed; bind to localhost only.
- Prefer eBPF kube-proxy replacement (Cilium) for performance + policy; secure mesh proxy config.
**Cross-links:** [API Server Bypass Risks](../../01-security/15-api-server-bypass-risks/), [Cluster Networking](../../04-cluster-administration/05-cluster-networking/), [RBAC](../../../kubernetes-security/04-authorization-rbac/).
