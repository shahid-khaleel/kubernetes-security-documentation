# Resource Quotas

**What it is.** A namespaced hard cap on **aggregate** consumption: total CPU/memory
requests+limits, object counts (pods, services, secrets, PVCs), and LoadBalancer count.

**Why it matters (security).** The primary **tenant-isolation / anti-DoS** control — one
namespace can't consume the whole cluster or create unlimited objects (e.g. secret/PVC
exhaustion). Essential for multi-tenancy.

**Example:** [examples/resourcequota.yaml](examples/resourcequota.yaml)

**Best practices:** set per-tenant quotas; cap `count/*` objects (incl. `services.loadbalancers`,
`secrets`); require requests/limits (works with LimitRange to auto-fill). **Cross-links:**
[Limit Ranges](../01-limit-ranges/), [PID Limits](../03-process-id-limits-and-reservations/), [Multi-tenancy](../../01-security/11-multi-tenancy/).
