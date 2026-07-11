# Operator Pattern

**What it is.** An **operator** = a **CRD** + a **custom controller** that watches those CRs and
reconciles real-world state (deploys, backups, upgrades) — encoding operational knowledge as
software. Built with kubebuilder/Operator SDK/controller-runtime.

**Why it matters (security).** Operators are **privileged automation**: they typically hold
broad RBAC (create/manage workloads, secrets, RBAC) and run continuously. A compromised or
over-permissioned operator is a **cluster-takeover path**; a supply-chained operator image runs
your infra. Many CVEs stem from operators granting themselves `cluster-admin`.

**Best practices**
- **Least-privilege RBAC** for the operator SA — scope to exactly the resources/namespaces it
  manages; **never** `cluster-admin` (audit operator RBAC on install).
- **Pin/scan/sign** the operator image; verify at admission ([supply chain](../../../kubernetes-security/17-image-security-and-signing-cosign-sigstore/)).
- Run the operator itself hardened (non-root, read-only fs, drop caps, seccomp).
- Validate CR input (schema/CEL/webhook); handle secrets via Vault/CSI, not plaintext CRs.
- Namespace-scope operators where possible; monitor what they create (drift/anomaly).
- Prefer **OLM/verified operators**; review community operators' RBAC before installing.

**Example — scoped operator RBAC (concept)**
```yaml
kind: ClusterRole            # only what it manages, NOT cluster-admin
rules:
  - apiGroups: ["apps"]
    resources: ["deployments","statefulsets"]
    verbs: ["get","list","watch","create","update","patch","delete"]
  - apiGroups: ["ops.example.com"]
    resources: ["backups","backups/status"]
    verbs: ["*"]
```
**Cross-links:** [Extending the API](../02-extending-the-kubernetes-api/), [RBAC Good Practices](../../01-security/09-rbac-good-practices/), [Installing Addons](../../05-observability/11-installing-addons/).
