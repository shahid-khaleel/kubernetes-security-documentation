# Admission Webhook Good Practices

**What it is.** Guidance for building/operating **validating & mutating admission webhooks**
(the extension point behind Kyverno/Gatekeeper and custom policy). A webhook is an HTTPS
service the API server calls before persisting objects.

**Why it matters (security).** Webhooks are **powerful and risky**: a mutating webhook can
inject sidecars/change security fields; `failurePolicy` decides fail-open vs fail-closed; a
compromised or slow webhook can weaken security or **DoS the whole API server**.

**Good practices**
- **`failurePolicy: Fail`** for security policies (fail closed); `Ignore` only for
  non-critical mutations (avoid silent bypass).
- **Scope with `namespaceSelector`/`objectSelector`**; **never intercept `kube-system`** in a
  way that can brick the cluster; exclude the webhook's own namespace (avoid deadlock).
- Set tight **`timeoutSeconds`** (webhook latency adds to every request); make the service HA.
- Serve **TLS** with a rotated CA bundle; least-privilege RBAC for the webhook SA; scan/sign its image.
- Prefer **`reinvocationPolicy`** awareness for mutating webhooks; keep logic idempotent.

**Example (skeleton)**
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata: { name: policy.example.com }
webhooks:
  - name: validate.policy.example.com
    failurePolicy: Fail                 # security -> fail closed
    timeoutSeconds: 5
    namespaceSelector:
      matchExpressions: [{ key: kubernetes.io/metadata.name, operator: NotIn, values: ["kube-system"] }]
    admissionReviewVersions: ["v1"]
    sideEffects: None
    clientConfig: { service: { name: policy, namespace: policy, path: /validate }, caBundle: <CA> }
    rules: [{ apiGroups: [""], apiVersions: ["v1"], operations: ["CREATE","UPDATE"], resources: ["pods"] }]
```
**Cross-links:** [Admission Controllers](../../../kubernetes-security/05-admission-controllers/), [API Priority & Fairness](../10-api-priority-and-fairness/).
