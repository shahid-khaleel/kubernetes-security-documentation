# Lab — Tenant Isolation
1. Apply `examples/tenant-namespace-isolation.yaml` for tenant-a and tenant-b.
2. Prove: tenant-a pod cannot reach tenant-b (default-deny), cannot exceed quota, must be restricted-compliant.
3. Try cross-namespace secret access with tenant-a RBAC → denied.
**Deliverable:** evidence of network + quota + RBAC isolation between tenants.
