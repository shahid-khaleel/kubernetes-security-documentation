# Lab — Secrets: base64 ≠ encryption
1. Create a secret; `kubectl get secret x -o jsonpath='{.data.password}' | base64 -d` → plaintext (encoding only!).
2. Apply the scoped RBAC in `examples/secret-and-rbac.yaml`; verify `can-i get secrets` is limited by resourceName.
3. Then do module 13 to actually encrypt at rest, and module 14 to externalize.
**Deliverable:** show the trivial base64 decode → motivate encryption + RBAC.
