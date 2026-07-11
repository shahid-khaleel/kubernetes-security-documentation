# Service Accounts

**What it is.** A ServiceAccount (SA) is the **identity a pod uses to call the Kubernetes
API**. Its token (a JWT) is mounted into the pod; RBAC bound to the SA defines what the pod
can do. Modern K8s issues **bound tokens** — short-lived, audience-scoped, auto-rotated.

**Why it matters.** A stolen SA token = the attacker inherits that SA's RBAC. The `default`
SA is mounted into every pod, so token hygiene + least-privilege RBAC bound the blast radius.

**Example — dedicated SA, no automount unless needed**
```yaml
apiVersion: v1
kind: ServiceAccount
metadata: { name: app-sa, namespace: apps }
automountServiceAccountToken: false
---
apiVersion: v1
kind: Pod
metadata: { name: app, namespace: apps }
spec:
  serviceAccountName: app-sa
  automountServiceAccountToken: true      # opt in only when the pod calls the API
  containers: [{ name: app, image: app:1.0 }]
```

**Best practices:** never use `default` for real apps; `automountServiceAccountToken:false`
by default; projected **bound tokens** (short TTL + audience); rotate on incident.
**Cross-links:** deep dive → [security/11](../../../kubernetes-security/11-service-accounts/), [RBAC](../../../kubernetes-security/04-authorization-rbac/).
