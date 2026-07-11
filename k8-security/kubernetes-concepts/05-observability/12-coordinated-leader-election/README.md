# Coordinated Leader Election

**What it is.** How HA control-plane components (controller-manager, scheduler) elect a single
active **leader** via a Lease object, so only one instance acts at a time; **coordinated leader
election** improves failover behavior during upgrades/skew.

**Why it matters (security/availability).** Leader election underpins **control-plane HA** —
correct failover keeps the cluster manageable during node loss or attack. The **Lease** objects
are RBAC-controlled; an attacker able to write them could disrupt leadership (a control-plane
DoS). Split-brain from misconfig risks inconsistent state.

**Best practices**
- Run ≥3 control-plane replicas; restrict RBAC on `coordination.k8s.io/leases`.
- Monitor leader transitions (excessive flapping = a problem); tune lease/renew timeouts.
- Ensure graceful failover during upgrades (coordinated election reduces disruption).
**Cross-links:** [control-plane security](../../../kubernetes-security/01-control-plane-security/), [Compatibility Version](../04-compatibility-version-control-plane/), [Backup/DR](../../../kubernetes-security/24-backup-and-disaster-recovery/).
