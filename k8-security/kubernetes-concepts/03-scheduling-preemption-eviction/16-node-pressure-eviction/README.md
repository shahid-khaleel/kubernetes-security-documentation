# Node-pressure Eviction

**What it is.** The **kubelet** proactively evicts pods when a node runs low on resources
(memory, disk, inodes, PIDs) based on **eviction thresholds** (`--eviction-hard`), reclaiming
resources to keep the node stable. Distinct from API-initiated eviction.

**Why it matters (security/availability).** Contains resource-exhaustion (a fork bomb / memory
leak / log-flood DoS) before it crashes the whole node and kubelet. Eviction order uses pod
priority + QoS (BestEffort evicted first) — so set requests/limits and priority intentionally.

**Example — kubelet thresholds**
```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
evictionHard:
  memory.available: "500Mi"
  nodefs.available: "10%"
  pid.available: "10%"
```
**Best practices:** set requests/limits (Guaranteed QoS survives longest); reserve system
resources; monitor eviction events; combine with PID/quota limits.
**Cross-links:** [API-initiated Eviction](../17-api-initiated-eviction/), [PID Limits](../../02-policies/03-process-id-limits-and-reservations/), [Limit Ranges](../../02-policies/01-limit-ranges/).
