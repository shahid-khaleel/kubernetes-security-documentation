# Pod Topology Spread Constraints

**What it is.** Rules (`topologySpreadConstraints`) that evenly distribute pods across
topology domains (zones, nodes) within a `maxSkew`, with `whenUnsatisfiable`
(DoNotSchedule/ScheduleAnyway).

**Why it matters (availability/DR).** Spreading replicas across zones/nodes ensures a single
node/zone failure — or a targeted attack on one node — can't take down all replicas. A core
**availability** control (SOC2 A1.2).

**Example:** [examples/topology-spread.yaml](examples/topology-spread.yaml)
**Best practices:** spread across `topology.kubernetes.io/zone` with `maxSkew:1`,
`DoNotSchedule` for critical services; combine with pod anti-affinity per node.
**Cross-links:** [Topology-Aware Scheduling](../02-topology-aware-workload-scheduling/), [Backup/DR](../../../kubernetes-security/24-backup-and-disaster-recovery/).
