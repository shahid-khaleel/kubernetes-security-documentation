# 23 — Multi-Tenancy

> **Track:** Kubernetes Security · **Level:** ⚫ · **Refs:** NIST SC-2/SC-7/AC-4, ISO A.8.22

**Objectives:** choose an isolation model (namespaces vs virtual clusters vs separate clusters); combine RBAC+NetworkPolicy+PSA+quotas+MAC.

## 1–5. Concept
Multi-tenancy runs multiple teams/customers on shared infrastructure — the isolation must be
**strong enough for the threat model**. Models (increasing isolation/cost): **namespace-per-tenant**
(soft — shared control plane & kernel), **virtual clusters** (vCluster — separate API server per
tenant), **cluster-per-tenant** (hard — separate everything). Soft multi-tenancy layers *all*
the controls: RBAC (04), NetworkPolicy (15), PSA restricted (06), ResourceQuota/LimitRange,
MAC/MCS (09), and node isolation for sensitive tenants.

## 6–7. Risks & attacks
- **Noisy neighbor** / resource-exhaustion DoS; **cross-tenant** access via over-broad RBAC or
  missing NetworkPolicy; **container escape** breaking the shared kernel → all tenants (T1611);
  shared cluster-scoped resources (CRDs, webhooks) leaking across tenants.

## 9–10. Best practices & hardening
- Per-tenant **namespace + quota + limits + default-deny network + PSA restricted**:
  [examples/tenant-namespace-isolation.yaml](examples/tenant-namespace-isolation.yaml). Unique **SELinux MCS** per tenant (09).
- For untrusted tenants: **sandboxed runtimes** (gVisor/Kata) or **separate clusters/nodes**.
  Scope RBAC so no tenant sees another's objects; avoid shared cluster-wide grants.

## 11. Compliance
| NIST SC-2/SC-7/AC-4 | ISO A.8.22 | PCI 1.x (segmentation) | SOC2 CC6.6 |
|---|---|---|---|
| isolation/boundary/flow | segregation | segmentation | boundary |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Three tenancy models? Which controls enforce soft isolation? Why is the shared kernel the weak point? **Interview —** *B:* Namespace isolation limits? *I:* Build a tenant isolation kit. *A:* Choose a model for untrusted tenants + justify. **Scenario:** SaaS onboarding untrusted tenants → assess threat model, pick vCluster or sandboxed runtime + node pools, layer RBAC/NetworkPolicy/PSA/quota/MCS, verify no cross-tenant reach.
