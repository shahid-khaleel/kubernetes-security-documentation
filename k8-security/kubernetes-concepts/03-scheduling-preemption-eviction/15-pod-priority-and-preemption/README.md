# Pod Priority and Preemption

**What it is.** **PriorityClasses** assign pods a priority; when a high-priority pod can't
schedule, the scheduler may **preempt (evict) lower-priority pods** to make room.

**Why it matters (security).** Priority is a **double-edged** control: it protects critical/
security workloads (Falco, ingress, monitoring) from eviction — but if tenants can set high
priority, they can **preempt others (DoS)**. Restrict who can use high PriorityClasses.

**Example:** [examples/priorityclass.yaml](examples/priorityclass.yaml)
**Best practices:** reserve high priorities for system/security workloads; use **admission
policy/RBAC** to stop tenants setting high `priorityClassName`; give critical pods a PDB;
`preemptionPolicy: Never` for pods that shouldn't preempt.
**Cross-links:** [Workload-Aware Preemption](../14-workload-aware-preemption/), [Scheduler Hardening](../../01-security/14-hardening-scheduler-configuration/).
