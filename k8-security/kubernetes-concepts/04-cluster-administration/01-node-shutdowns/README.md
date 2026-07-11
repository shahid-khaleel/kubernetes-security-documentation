# Node Shutdowns (Graceful)

**What it is.** **Graceful node shutdown** lets the kubelet detect a system shutdown signal and
terminate pods in order (respecting `terminationGracePeriod` and pod priority) before the node
powers off — via `shutdownGracePeriod`/`shutdownGracePeriodCriticalPods` kubelet settings.

**Why it matters (availability/security).** Ungraceful shutdowns can corrupt stateful data,
skip cleanup (leaving secrets/creds in memory or temp files), and cause abrupt outages.
Graceful shutdown = clean teardown = better availability + hygiene. Non-graceful shutdown
handling (with taints) enables safe stateful failover.

**Example — kubelet config**
```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
shutdownGracePeriod: "30s"
shutdownGracePeriodCriticalPods: "10s"
```
**Best practices:** enable graceful shutdown; use the **out-of-service taint** for non-graceful
node failures so StatefulSet pods can reschedule; combine with PDBs and API-initiated drain
for planned maintenance.
**Cross-links:** [API-initiated Eviction](../../03-scheduling-preemption-eviction/17-api-initiated-eviction/), [Node Autoscaling](../03-node-autoscaling/).
