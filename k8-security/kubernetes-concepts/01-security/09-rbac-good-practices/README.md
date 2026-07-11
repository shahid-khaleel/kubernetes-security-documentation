# RBAC Good Practices

**What it is.** Practical rules for least-privilege Role-Based Access Control (the concept is
detailed in [security/04](../../../kubernetes-security/04-authorization-rbac/)).

**Why it matters.** Most real cluster compromises escalate through over-broad RBAC — a token
that can `get secrets` cluster-wide or a SA bound to `cluster-admin`.

**The good-practices list**
- **Least privilege & default-deny:** grant only needed verbs/resources; namespaced Roles > ClusterRoles.
- **No wildcards** (`*` verbs/resources/apiGroups) — they include future resources too.
- **Never bind `cluster-admin` to a ServiceAccount**; rarely to humans (JIT + MFA).
- **Scope Secrets** with `resourceNames`; prefer read-only where possible.
- **Prefer groups** (via OIDC) over per-user bindings — offboarding is one IdP change.
- **Watch escalation verbs:** `escalate`, `bind`, `impersonate`, and write to RBAC objects.
- **Remember indirect escalation:** `create pods`/controllers + weak Pod Security → node escape;
  `create serviceaccounts/token` → mint other SAs' tokens.
- **Review continuously:** `kubectl auth can-i --list --as ...`; alert on `cluster-admin` bindings.

**Example — scope a secret grant**
```yaml
rules:
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["db-cred"]   # not all secrets
  verbs: ["get"]
```
**Cross-links:** deep dive + audit scripts → [security/04](../../../kubernetes-security/04-authorization-rbac/), [k8s-quick-audit.sh](../../../scripts/k8s-quick-audit.sh).
