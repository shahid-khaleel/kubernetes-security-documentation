# Kubernetes Scheduler

**What it is.** `kube-scheduler` watches for unscheduled pods and binds each to a node via a
two-phase process: **Filtering** (which nodes *can* run it — resources, taints, affinity,
node selectors) then **Scoring** (which node is *best* — spread, utilization).

**Why it matters (security).** Placement decisions affect the blast radius: sensitive pods
should land on trusted/isolated nodes; tenant pods must be kept off them. The scheduler is a
control-plane component — harden and vet any custom plugins.

```
unscheduled pod ─► FILTER (feasible nodes) ─► SCORE (rank) ─► BIND to best node
                    taints/affinity/resources    spread/util
```
**Best practices:** use taints/affinity to constrain placement ([topic 07](../07-taints-and-tolerations/),[03](../03-assigning-pods-to-nodes/)); harden scheduler config ([sec hardening](../../01-security/14-hardening-scheduler-configuration/)); enforce quotas so scheduling can't be weaponized for DoS.
