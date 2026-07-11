# Taints and Tolerations

**What it is.** **Taints** on nodes *repel* pods; **tolerations** on pods let them tolerate a
taint. Effects: `NoSchedule`, `PreferNoSchedule`, `NoExecute` (also evicts running pods).

**Why it matters (security).** The enforcement half of node isolation: taint sensitive/
dedicated nodes so **only** workloads with the matching toleration land there (PCI-isolated
pools, GPU nodes, control-plane). Pair with **required node affinity** for two-way binding.

**Example:** [examples/taint-toleration.yaml](examples/taint-toleration.yaml)
**Best practices:** dedicate node pools with a taint + require both toleration AND node
affinity (toleration alone doesn't *force* placement); use `NoExecute` to evict on
compromise/maintenance.
**Cross-links:** [Assigning Pods to Nodes](../03-assigning-pods-to-nodes/), [Node-pressure Eviction](../16-node-pressure-eviction/), [Multi-tenancy](../../01-security/11-multi-tenancy/).
