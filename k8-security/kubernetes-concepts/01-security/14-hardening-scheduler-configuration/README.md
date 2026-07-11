# Hardening Guide — Scheduler Configuration

**What it is.** Securing `kube-scheduler` and its **KubeSchedulerConfiguration** (profiles,
plugins). The scheduler decides pod placement; misconfig can be abused for DoS or to land
sensitive pods on attacker-influenced nodes.

**Why it matters (security).** A permissive scheduler + weak admission lets an attacker who
can create pods influence placement (e.g. onto a node with secrets), or exhaust a node.
Custom scheduler plugins run in the control plane — trusted code only.

**Hardening**
- Run scheduler with least privilege; `--profiling=false`; secure its kubeconfig/certs.
- Use **taints/tolerations + node affinity** so tenant pods can't schedule onto sensitive
  nodes ([Taints](../../03-scheduling-preemption-eviction/07-taints-and-tolerations/)).
- Enforce **ResourceQuota/LimitRange** so pods can't exhaust nodes (scheduler DoS).
- Vet any **custom scheduler plugins/out-of-tree schedulers** (supply chain).
- Combine with **Pod Priority** carefully — high priority can preempt others (abuse vector).

**Cross-links:** [Scheduler](../../03-scheduling-preemption-eviction/01-kubernetes-scheduler/), [Priority & Preemption](../../03-scheduling-preemption-eviction/15-pod-priority-and-preemption/), [control-plane security](../../../kubernetes-security/01-control-plane-security/).
