# Extending the Kubernetes API (CRDs & Aggregation)

**What it is.** Two ways to add new API types/endpoints:
- **CustomResourceDefinitions (CRDs)** — declare new resource kinds served by the apiserver
  (the basis of operators/policy engines).
- **API Aggregation Layer** — register an **extension apiserver** for custom API groups.

**Why it matters (security).** New APIs = **new RBAC surface + new admission scope**. CRDs need
their own RBAC (a `*` on `*` grant now covers your CRs too); an aggregated apiserver is a
**trusted component** the main apiserver proxies to (its compromise ≈ apiserver compromise).
Weak CRD **validation** lets bad data through.

**Example — a CRD with validation:** [examples/crd.yaml](examples/crd.yaml)
**Best practices**
- **Scope RBAC explicitly** to CRD groups/resources (don't rely on wildcards; audit them).
- Use **OpenAPI schema validation** + **CEL validation rules** / validating webhooks on CRs.
- Secure aggregated apiservers (mTLS, RBAC, patched, least-priv SA) — treat as control plane.
- Version CRDs; guard `status` vs `spec` update permissions separately.
**Cross-links:** [Operator Pattern](../03-operator-pattern/), [Admission Webhook Good Practices](../../05-observability/01-admission-webhook-good-practices/), [RBAC](../../../kubernetes-security/04-authorization-rbac/).
