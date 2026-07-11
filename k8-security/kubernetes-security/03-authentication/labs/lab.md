# Lab — X.509 Client-Cert Identity + kubeconfig
1. Run `examples/generate-user-cert.sh` to mint a `dev-alice`/`developers` identity.
2. `kubectl --context alice get pods` → Forbidden (authenticated but no RBAC yet — that's module 04).
3. Decode a service-account JWT: `kubectl create token default | cut -d. -f2 | base64 -d | jq`.
**Deliverable:** show the CN/O maps to username/group, and the SA token claims.
