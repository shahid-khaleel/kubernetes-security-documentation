# Pod Security Standards (PSS)

**What it is.** Three cumulative security profiles Kubernetes defines for pods:
- **Privileged** — unrestricted (system/infra workloads only).
- **Baseline** — blocks known privilege escalations: no `privileged`, no host namespaces,
  no hostPath, no added dangerous capabilities, restricted `hostPort`.
- **Restricted** — hardened best practice: `runAsNonRoot`, drop **ALL** capabilities (add
  only `NET_BIND_SERVICE`), `seccompProfile: RuntimeDefault`, `allowPrivilegeEscalation:false`,
  restricted volume types.

**Why it matters.** They are the *standard definition of "a safe pod,"* enforced by Pod
Security Admission (next topic). Restricted is the target for regulated workloads.

**Example — a Restricted-compliant pod**
```yaml
apiVersion: v1
kind: Pod
metadata: { name: restricted-ok }
spec:
  securityContext: { runAsNonRoot: true, seccompProfile: { type: RuntimeDefault } }
  containers:
  - name: app
    image: registry.example.com/app@sha256:...
    securityContext:
      allowPrivilegeEscalation: false
      capabilities: { drop: ["ALL"] }
      runAsUser: 10001
      readOnlyRootFilesystem: true
```

**Best practices:** target **Restricted** everywhere except system namespaces; use
Baseline as a migration step.
**Cross-links:** deep dive → [security/06 — Pod Security Admission](../../../kubernetes-security/06-pod-security-admission/), [Security Context](../../../kubernetes-security/07-security-contexts/).
