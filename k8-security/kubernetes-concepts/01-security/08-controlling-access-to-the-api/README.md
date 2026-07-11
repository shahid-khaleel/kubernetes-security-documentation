# Controlling Access to the Kubernetes API

**What it is.** The full request pipeline every API call passes through:
**Transport (TLS) → Authentication → Authorization → Admission Control → Persistence**.

```
kubectl/pod ──TLS──► [ AuthN: who? ] ──► [ AuthZ: allowed? ] ──► [ Admission: valid/mutated? ] ──► etcd
             certs/OIDC/SA token        Node,RBAC,Webhook        validating+mutating webhooks
```

**Why it matters.** This is the cluster's front door; every other control hangs off these
stages. Understanding the pipeline explains *where* to apply each defense.

**Hardening per stage**
- **Transport:** TLS everywhere; `--anonymous-auth=false`.
- **AuthN:** OIDC+MFA for humans, bound tokens for workloads ([security/03](../../../kubernetes-security/03-authentication/)).
- **AuthZ:** `--authorization-mode=Node,RBAC`; least-privilege RBAC ([security/04](../../../kubernetes-security/04-authorization-rbac/)).
- **Admission:** PSA + Kyverno/Gatekeeper ([security/05](../../../kubernetes-security/05-admission-controllers/),[06](../../../kubernetes-security/06-pod-security-admission/)).
- **Behind it:** encrypt etcd ([security/13](../../../kubernetes-security/13-encryption-at-rest/)); audit log everything ([security/20](../../../kubernetes-security/20-audit-logging/)).

**Best practices:** never expose the API to the internet without a private endpoint/allowlist;
disable insecure ports; watch **API bypass paths** ([topic 15](../15-api-server-bypass-risks/)).
