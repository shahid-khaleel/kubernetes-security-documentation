# Lab — Network Segmentation + Safe Volumes
1. `docker compose -f examples/isolated-network-compose.yaml up -d`.
2. Prove `db` is unreachable from the public net and has no internet egress (`internal: true`).
3. Show a bind-mount permission pitfall and fix with `:ro` + correct uid.
**Deliverable:** connectivity matrix proving tier isolation.
