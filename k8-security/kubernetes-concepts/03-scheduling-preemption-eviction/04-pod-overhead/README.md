# Pod Overhead

**What it is.** Accounting for the **per-pod resource cost of the runtime sandbox** itself
(e.g. the memory/CPU a Kata/gVisor VM/sandbox consumes beyond the containers). Configured via
a **RuntimeClass** `overhead` field and added to scheduling/quota calculations.

**Why it matters (security).** **Sandboxed runtimes** (gVisor/Kata) are a key isolation
control for untrusted/multi-tenant workloads — Pod Overhead makes the scheduler and quotas
account for their real cost so you don't over-pack nodes and cause instability.

**Example:** [examples/runtimeclass-overhead.yaml](examples/runtimeclass-overhead.yaml)
**Best practices:** set realistic overhead for sandboxed RuntimeClasses; factor into quotas.
**Cross-links:** [docker/04 — gVisor/Kata](../../../docker-security/04-containerd-runc/), [Multi-tenancy](../../01-security/11-multi-tenancy/).
