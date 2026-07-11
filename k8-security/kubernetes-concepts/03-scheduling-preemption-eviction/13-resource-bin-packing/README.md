# Resource Bin Packing

**What it is.** A scheduling strategy that **packs pods densely** onto fewer nodes (via the
`MostAllocated`/`RequestedToCapacityRatio` scoring strategy) to improve utilization — the
opposite of spreading. Also applies to extended resources (GPUs).

**Why it matters (security/cost/availability trade-off).** Bin-packing cuts cost and idle
nodes, but **densely packed nodes concentrate blast radius** (one node failure/compromise
affects more pods) and reduce spread. It's a deliberate trade-off vs topology spread.

**Example — scoring strategy**
```yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - pluginConfig:
      - name: NodeResourcesFit
        args:
          scoringStrategy: { type: MostAllocated }   # pack tightly
```
**Best practices:** bin-pack batch/non-critical tiers; **spread** critical/HA tiers across
zones (topic 06); don't bin-pack multi-tenant untrusted workloads onto shared nodes.
**Cross-links:** [Topology Spread](../06-pod-topology-spread-constraints/), [Node Autoscaling](../../04-cluster-administration/03-node-autoscaling/).
