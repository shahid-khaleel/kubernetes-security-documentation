# Pod Security Admission (PSA)

**What it is.** The built-in admission controller (GA 1.25, replaced PodSecurityPolicy) that
enforces the Pod Security Standards **per namespace** via labels, in three modes:
`enforce` (reject), `audit` (annotate audit log), `warn` (return a warning to the user).

**Why it matters.** It's how PSS becomes *actually enforced* — the cheapest cluster-wide
guardrail stopping root/privileged/hostPath pods even when RBAC would otherwise allow them.

**Example — enforce Restricted, warn+audit at Restricted**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: payments
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/audit: restricted
```

**Best practices:** roll out `warn`/`audit` first to find violators, then `enforce`; pin
`enforce-version`; exempt only true system namespaces; layer Kyverno/Gatekeeper for
finer/exception policy (PSA is namespace-coarse).
**Cross-links:** deep dive → [security/06](../../../kubernetes-security/06-pod-security-admission/), [Admission Controllers](../../../kubernetes-security/05-admission-controllers/).
