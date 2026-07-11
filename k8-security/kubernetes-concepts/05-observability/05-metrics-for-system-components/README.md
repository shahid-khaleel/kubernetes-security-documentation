# Metrics for Kubernetes System Components

**What it is.** Control-plane and node components expose **Prometheus-format metrics** on
`/metrics` (apiserver, scheduler, controller-manager, kubelet, etcd) — request rates, latency,
error rates, queue depths, resource usage.

**Why it matters (security).** Metrics power **detection and availability**: spikes in
apiserver 401/403, authentication failures, admission webhook latency, or etcd errors are
**security signals** (probing, misconfig, DoS). The `/metrics` endpoint itself must be
**authN/authZ-protected** — it can leak cluster internals.

**Security-relevant metrics to alert on**
- `apiserver_request_total{code=~"401|403"}` spikes → auth probing / stolen-token misuse.
- `authentication_attempts{result="failure"}` → brute force.
- `apiserver_admission_webhook_rejection_count` → policy hits (or bypass attempts).
- `etcd_*` errors / latency → integrity/availability risk.
**Best practices:** protect `/metrics` (RBAC/authn); scrape into Prometheus; alert on the
above; correlate with audit logs.
**Cross-links:** [Metrics for Object States](../06-metrics-for-object-states/), [API Priority & Fairness](../10-api-priority-and-fairness/), [Audit Logging](../../../kubernetes-security/20-audit-logging/).
