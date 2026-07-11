# Gang Scheduling

**What it is.** All-or-nothing scheduling: a group of pods (e.g. a distributed ML/HPC job) is
scheduled **together or not at all**, avoiding partial placement that deadlocks on resources.
Provided by schedulers/plugins like **Kueue**, **Volcano**, or Coscheduling.

**Why it matters (security/availability).** Prevents resource **deadlock/waste** where half a
job holds GPUs waiting for the other half — a self-inflicted DoS. Batch/AI platforms rely on
it; the gang scheduler is control-plane code to vet.

**Example (Volcano PodGroup concept)** — see [PodGroup Scheduling](../12-podgroup-scheduling/).
**Best practices:** use a proven scheduler (Kueue/Volcano); set quotas so gangs can't starve
interactive workloads; sign/vet the scheduler images.
**Cross-links:** [Scheduling Framework](../08-scheduling-framework/), [PodGroup Scheduling](../12-podgroup-scheduling/), [Resource Bin Packing](../13-resource-bin-packing/).
