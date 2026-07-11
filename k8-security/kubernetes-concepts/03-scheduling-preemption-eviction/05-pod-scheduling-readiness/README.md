# Pod Scheduling Readiness

**What it is.** `schedulingGates` let you keep a pod **unschedulable** until external
conditions are met — the scheduler ignores the pod until all gates are removed (e.g. by a
controller/quota-manager).

**Why it matters (security/governance).** A **policy gate** before a workload can be placed:
e.g. don't schedule until a security scan/approval/quota-check passes, or until a
just-in-time credential is provisioned — enforced at the scheduling layer.

**Example:** [examples/scheduling-gate.yaml](examples/scheduling-gate.yaml)
**Best practices:** use gates for admission-adjacent governance (approval workflows, capacity)
that admission webhooks alone can't express; a controller removes the gate when ready.
**Cross-links:** [Scheduler](../01-kubernetes-scheduler/), [Admission Webhook Good Practices](../../05-observability/01-admission-webhook-good-practices/).
