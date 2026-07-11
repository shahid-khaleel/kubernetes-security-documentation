# Scheduler Performance Tuning

**What it is.** Tuning scheduler throughput on large clusters: `percentageOfNodesToScore`
(sample a subset of nodes when scoring), multiple scheduling **profiles**, and plugin
selection to reduce per-pod latency.

**Why it matters (security/availability).** A slow/overloaded scheduler delays pod placement —
including **security-critical** pods (a replacement after eviction, a DR failover). Scheduling
latency is an availability concern; tuning keeps it bounded at scale.

**Example — KubeSchedulerConfiguration**
```yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
percentageOfNodesToScore: 50     # score half the nodes on big clusters -> lower latency
profiles:
  - schedulerName: default-scheduler
```
**Best practices:** tune on large clusters; monitor `scheduler_scheduling_attempt_duration`;
don't sacrifice spread/anti-affinity for speed on critical workloads.
**Cross-links:** [Scheduler](../01-kubernetes-scheduler/), [Metrics for System Components](../../05-observability/05-metrics-for-system-components/).
