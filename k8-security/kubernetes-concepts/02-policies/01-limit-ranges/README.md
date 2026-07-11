# Limit Ranges

**What it is.** A namespaced policy that sets **default**, **min**, and **max** CPU/memory
(and PVC size) per Container/Pod. It auto-injects requests/limits when a workload omits them.

**Why it matters (security).** Prevents **resource-exhaustion DoS** and noisy-neighbor from a
single tenant, and guarantees every pod has limits (a Restricted/good-practice requirement).
Without it, a pod with no memory limit can OOM the node and evict neighbors.

**Example:** [examples/limitrange.yaml](examples/limitrange.yaml)

**Best practices:** set sane defaults + a max ceiling per tenant namespace; pair with
ResourceQuota; combine with PID limits. **Cross-links:** [Resource Quotas](../02-resource-quotas/), [Multi-tenancy](../../01-security/11-multi-tenancy/).
