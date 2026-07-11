# Metrics for Kubernetes Object States (kube-state-metrics)

**What it is.** **kube-state-metrics (KSM)** generates metrics about the *state of API objects*
— deployments, pods, nodes, RBAC, secrets, network policies — by listing the API (not resource
usage; that's the metrics-server/cAdvisor).

**Why it matters (security).** KSM turns **security posture into alertable metrics**: pods
running as root, containers without limits, namespaces missing NetworkPolicy, RBAC bindings,
secret counts, cert expiry. It's how you **continuously monitor drift** from hardened baselines.

**Security-relevant series**
- `kube_pod_container_status_running` + securityContext exposure via KSM configs/CRD metrics.
- `kube_networkpolicy_*` presence per namespace; `kube_secret_*` counts.
- `kube_certificate_signingrequest_*`; `kube_node_status_condition`.
- Custom **CRD/config metrics** to surface `runAsNonRoot`, `privileged`, image registries.
**Best practices:** deploy KSM; build Grafana/alerts for "pods running as root", "ns without
NetworkPolicy", "cluster-admin bindings"; feed to the security dashboard.
**Cross-links:** [Metrics — System Components](../05-metrics-for-system-components/), [k8s-quick-audit.sh](../../../scripts/k8s-quick-audit.sh), [Security Checklist](../../01-security/17-security-checklist/).
