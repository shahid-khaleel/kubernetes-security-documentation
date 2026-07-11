# Scheduling Framework

**What it is.** The pluggable architecture inside kube-scheduler: a set of **extension points**
(QueueSort, PreFilter, Filter, Score, Reserve, Permit, PreBind, Bind, PostBind) where plugins
hook in. Built-in features (affinity, taints, spread) are themselves plugins.

**Why it matters (security).** Custom scheduling logic (gang scheduling, security-aware
placement) is implemented as **plugins running in the control plane** — trusted, signed code
only. It's also how policy like "don't schedule until approved" (Permit) is built.

```
QueueSort ─► PreFilter ─► Filter ─► Score ─► Reserve ─► Permit ─► PreBind ─► Bind ─► PostBind
```
**Best practices:** vet/sign out-of-tree plugins (supply chain); prefer configuration
(profiles) over custom code; monitor scheduler for latency/DoS.
**Cross-links:** [Scheduler](../01-kubernetes-scheduler/), [Gang Scheduling](../10-gang-scheduling/), [Scheduler Hardening](../../01-security/14-hardening-scheduler-configuration/).
