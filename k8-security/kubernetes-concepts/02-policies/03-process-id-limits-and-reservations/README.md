# Process ID (PID) Limits & Reservations

**What it is.** Controls on PIDs — a finite kernel resource. **Per-pod** PID limits
(`SupportPodPidsLimit`, kubelet `--pod-max-pids`) cap processes per pod; **node PID
reservation** (`--system-reserved=pid=...`, `SupportNodePidsLimit`) reserves PIDs for the OS.

**Why it matters (security).** A **fork bomb** in one pod can exhaust node PIDs and take down
the kubelet and every other pod. PID limits contain it (the cgroups lesson, applied in K8s).

**Example — kubelet config**
```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
podPidsLimit: 1024                 # max PIDs per pod
systemReserved: { pid: "1000" }    # reserve PIDs for the node OS
```
Or a namespace-wide cap via ResourceQuota:
```yaml
spec: { hard: { count/pods: "50" } }   # bounds total processes indirectly
```
**Best practices:** always set `podPidsLimit` on multi-tenant nodes; reserve node PIDs.
**Cross-links:** [docker/03 — cgroups & fork-bomb defense](../../../docker-security/03-cgroups/), [Node-pressure Eviction](../../03-scheduling-preemption-eviction/16-node-pressure-eviction/).
