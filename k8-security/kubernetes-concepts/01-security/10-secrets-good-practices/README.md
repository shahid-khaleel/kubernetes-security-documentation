# Good Practices for Kubernetes Secrets

**What it is.** Guidance for handling the Secret object safely (mechanics in
[security/12](../../../kubernetes-security/12-secrets-management/)).

**Why it matters.** Secrets are **base64, not encrypted**, stored in etcd, and readable by
anyone with `get secrets` RBAC — the #1 credential-theft target.

**The good-practices list**
- **Enable encryption at rest** (KMS) — [security/13](../../../kubernetes-security/13-encryption-at-rest/).
- **Least-privilege RBAC** on Secrets; scope with `resourceNames`; audit who can read them.
- **Mount as files, not env vars** (env leaks via `/proc/<pid>/environ`, crash logs, `inspect`).
- **Externalize** to Vault/cloud via ESO or the **Secrets Store CSI driver** — [security/14](../../../kubernetes-security/14-external-secrets-and-vault/).
- **Never commit Secrets to Git**; for GitOps use Sealed Secrets / SOPS / ESO.
- **Rotate** regularly and on any suspected exposure; prefer **short-lived/dynamic** secrets.
- **Disable secret auto-mount** where unused; restrict `configmaps` used as pseudo-secrets.

**Example — file mount (safer than env)**
```yaml
volumes: [{ name: cred, secret: { secretName: db-cred } }]
containers:
- name: app
  volumeMounts: [{ name: cred, mountPath: /etc/cred, readOnly: true }]
```
**Cross-links:** [security/12](../../../kubernetes-security/12-secrets-management/), [13](../../../kubernetes-security/13-encryption-at-rest/), [14](../../../kubernetes-security/14-external-secrets-and-vault/).
