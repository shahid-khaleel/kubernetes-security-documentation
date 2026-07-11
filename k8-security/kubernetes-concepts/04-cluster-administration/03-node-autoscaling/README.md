# Node Autoscaling

**What it is.** Automatically adding/removing **nodes** to match workload demand — via the
**Cluster Autoscaler** (scales node groups when pods are Pending / nodes underused) or
**Karpenter** (provisions right-sized nodes just-in-time).

**Why it matters (security).** Autoscaling spins up **new nodes automatically** — each must be
born hardened (golden image, CIS baseline, correct IAM). Misconfigured autoscaling is a
**cost-DoS** vector (an attacker who can create Pending pods forces unbounded node creation).
New nodes also expand the attack surface and IAM blast radius.

**Best practices**
- Harden the **node template/AMI** (immutable, CIS, minimal); scoped node IAM role (no `*`).
- **Cap** max nodes/node-group size; enforce ResourceQuota so pods can't trigger runaway scale-up.
- Ensure new nodes auto-enroll runtime detection (Falco) + logging; fast patch pipeline.
- Karpenter/CA controller has powerful cloud perms — least-privilege + audit it.

**Cross-links:** [Resource Bin Packing](../../03-scheduling-preemption-eviction/13-resource-bin-packing/), [Security for Linux Nodes](../../01-security/06-security-for-linux-nodes/), [Resource Quotas](../../02-policies/02-resource-quotas/).
