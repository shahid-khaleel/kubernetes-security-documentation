# PodGroup Scheduling

**What it is.** A **PodGroup** (from batch schedulers like Volcano/Coscheduling) declares a
set of pods and a **minMember** — the group is scheduled only once `minMember` pods can be
placed. The concrete mechanism behind gang scheduling.

**Why it matters (security/availability).** Guarantees batch/AI jobs get an atomic resource
allocation, preventing partial-placement deadlock and resource waste (a self-DoS). PodGroups
also carry priority/queue semantics used for fair sharing across tenants.

**Example (Volcano)**
```yaml
apiVersion: scheduling.volcano.sh/v1beta1
kind: PodGroup
metadata: { name: ml-job, namespace: ml }
spec:
  minMember: 4                # schedule all 4 workers together or none
  queue: ml-queue
  priorityClassName: batch-normal
```
**Best practices:** set `minMember` = required workers; bind to a queue with quota; combine
with fair-share to isolate tenants.
**Cross-links:** [Gang Scheduling](../10-gang-scheduling/), [Priority & Preemption](../15-pod-priority-and-preemption/).
