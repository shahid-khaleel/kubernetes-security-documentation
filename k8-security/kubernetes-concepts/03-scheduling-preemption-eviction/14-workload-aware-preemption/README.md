# Workload-Aware Preemption

**What it is.** Preemption that considers **workload context** (e.g. gang/PodGroup membership,
job semantics) rather than evicting individual pods blindly — so preempting to fit a
high-priority pod doesn't break a distributed job by killing one of its members.

**Why it matters (availability).** Naive preemption can cause cascading failures or deadlock
in batch/AI workloads; workload-aware preemption preserves group integrity and avoids
self-inflicted outages. Emerging area in batch schedulers (Kueue/Volcano).

**Best practices:** use PriorityClasses intentionally; test preemption behavior with
gang jobs; ensure critical services have `PodDisruptionBudget` + high priority so they aren't
preempted.
**Cross-links:** [Priority & Preemption](../15-pod-priority-and-preemption/), [Gang Scheduling](../10-gang-scheduling/), [PodGroup Scheduling](../12-podgroup-scheduling/).
