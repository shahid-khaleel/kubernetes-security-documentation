# Assigning Pods to Nodes

**What it is.** Mechanisms to constrain *where* a pod runs: `nodeSelector` (simple label
match), **node affinity/anti-affinity** (expressive, required/preferred), **pod
affinity/anti-affinity** (co-locate/separate relative to other pods), and `nodeName` (direct).

**Why it matters (security).** Keeps **sensitive workloads on trusted/isolated node pools**
and keeps **untrusted tenant pods off** them — a core multi-tenancy + data-isolation control.
Combine with taints so it's enforced, not just preferred.

**Example:** [examples/node-affinity.yaml](examples/node-affinity.yaml)

**Best practices:** use **required** node affinity + matching node **taints** for hard
isolation (PCI/regulated node pools); pod anti-affinity to spread replicas.
**Cross-links:** [Taints & Tolerations](../07-taints-and-tolerations/), [Topology Spread](../06-pod-topology-spread-constraints/), [Multi-tenancy](../../01-security/11-multi-tenancy/).
