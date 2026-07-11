# 12 — Secrets Management

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 5.4.x, PCI 3.x/8.x, NIST IA-5/SC-28

**Objectives:** understand base64≠encryption; scope Secret RBAC; use CSI secret stores; combine with encryption-at-rest & externalization.

## Concept
A K8s **Secret** stores sensitive data — but it's only **base64-encoded**, stored in **etcd**,
and readable by anyone with RBAC `get secrets` (and by anyone reading etcd, unless encrypted).
Real protection is layered: **(1)** RBAC scoping, **(2)** **encryption at rest** (module 13),
**(3)** **externalization** to Vault/cloud (module 14), and **(4)** the **Secrets Store CSI
driver** (mount from an external store, no etcd copy).

## Risks & attacks
- `kubectl get secret -o jsonpath | base64 -d` reveals plaintext (T1552). Broad `get/list
  secrets` RBAC → dump all creds. Secrets in env vars leak via `/proc`/crash logs. etcd exposure.

## Best practices & hardening
- **Scope RBAC** with `resourceNames` ([examples/secret-and-rbac.yaml](examples/secret-and-rbac.yaml)); prefer
  **file mounts over env**. Enable encryption at rest. Use **CSI SecretProviderClass**
  ([examples/csi-secrets-store-spc.yaml](examples/csi-secrets-store-spc.yaml)) or ESO (module 14).
- Rotate regularly; never commit Secrets to git (use sealed-secrets/SOPS/ESO for GitOps).

## Compliance
| CIS 5.4.x | PCI 3.x/8.x | ISO A.5.17/8.24 | NIST IA-5/SC-28 | HIPAA 164.312(a) |
|---|---|---|---|---|
| secret handling | protect/authN data | secret/crypto | authenticator/at-rest | access/encryption |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Is a Secret encrypted by default? Why file > env? What is the CSI driver for? **Interview —** *B:* How are Secrets stored? *I:* Scope + encrypt Secrets. *A:* Design secret management build→runtime with rotation + GitOps. **Scenario:** audit shows base64 secrets in etcd + broad RBAC → enable encryption at rest, scope RBAC, migrate to Vault/ESO, rotate everything.
