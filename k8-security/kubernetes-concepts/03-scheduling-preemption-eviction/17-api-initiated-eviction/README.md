# API-initiated Eviction

**What it is.** Graceful eviction via the **Eviction API** (`kubectl drain`, or POST
`pods/eviction`) that **respects PodDisruptionBudgets (PDBs)** — used for node maintenance,
upgrades, and **incident response** (draining a compromised node).

**Why it matters (security/availability).** The safe way to remove pods from a node during
patching or after compromise **without violating availability guarantees** (PDBs stop you from
taking down too many replicas at once). Key IR tool: cordon + drain a suspect node.

**Example**
```bash
kubectl cordon node-x          # stop new scheduling
kubectl drain node-x --ignore-daemonsets --delete-emptydir-data   # evict, honoring PDBs
```
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata: { name: web-pdb }
spec: { minAvailable: 2, selector: { matchLabels: { app: web } } }
```
**Best practices:** define PDBs for critical services; cordon+drain during IR ([sec/26](../../../kubernetes-security/26-incident-response-and-threat-modeling/)); automate for patching.
**Cross-links:** [Node-pressure Eviction](../16-node-pressure-eviction/), [Node Shutdowns](../../04-cluster-administration/01-node-shutdowns/).
