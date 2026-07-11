# Lab — External Secrets Operator
1. Install ESO (helm). Stand up dev Vault: `vault server -dev`.
2. Apply `examples/externalsecret.yaml`; confirm a native Secret gets created & refreshed.
3. Rotate the value in Vault → watch the k8s Secret update within refreshInterval.
**Deliverable:** show the synced Secret + auto-rotation.
