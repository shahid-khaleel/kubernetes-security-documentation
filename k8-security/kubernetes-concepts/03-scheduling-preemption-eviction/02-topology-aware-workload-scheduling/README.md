# Topology-Aware Workload Scheduling

**What it is.** Placing pods with awareness of physical/logical **topology** — zones, racks,
NUMA nodes — for availability, performance, and data-locality. Includes topology spread,
zone-aware volume binding, and Topology Manager (NUMA alignment) on the node.

**Why it matters (security/availability).** Spreading replicas across zones/racks prevents a
single failure (or a targeted node attack) from taking down a whole service — an
**availability** control (SOC2 A1, DR). Data-locality can also keep regulated data in-region
(GDPR data residency).

**Example (spread across zones):** see [Pod Topology Spread Constraints](../06-pod-topology-spread-constraints/).
**Best practices:** spread critical workloads across ≥3 zones; use `volumeBindingMode:
WaitForFirstConsumer` for zone-correct PVs; align data residency to region constraints.
**Cross-links:** [Topology Spread](../06-pod-topology-spread-constraints/), [Assigning Pods to Nodes](../03-assigning-pods-to-nodes/).
