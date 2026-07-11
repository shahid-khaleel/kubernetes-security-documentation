# 07 — Security Contexts

> **Track:** Kubernetes Security · **Level:** 🟡 · **Refs:** CIS K8s 5.2.x, NSA/CISA, NIST AC-6

**Objectives:** set pod/container security fields (runAsNonRoot, readOnlyRootFilesystem, drop caps, no-privesc, seccomp, fsGroup).

## Concept
A **securityContext** applies Linux security settings to pods/containers — the K8s expression
of the Linux/Docker hardening you learned: `runAsNonRoot`/`runAsUser`, `readOnlyRootFilesystem`,
`allowPrivilegeEscalation:false`, `capabilities.drop:[ALL]`, `seccompProfile`, `fsGroup`,
`privileged:false`. These are what PSA/`restricted` (module 06) actually checks for.

## Risks it reduces
- Running as **root** in the container → root on mounted volumes/host paths, easier escape.
- Writable rootfs → persistence/tampering. Privilege escalation via setuid. Excess capabilities.

## Best practices & hardening
- The full hardened pattern: [examples/securitycontext-hardened-deployment.yaml](examples/securitycontext-hardened-deployment.yaml) —
  non-root numeric UID, drop ALL caps, read-only rootfs (+ emptyDir for writable paths),
  `allowPrivilegeEscalation:false`, seccomp RuntimeDefault, `automountServiceAccountToken:false`.
- Set at pod level, override per container as needed. Verify inside: `id`, `touch /x` fails,
  `grep Cap /proc/1/status`.

## Compliance
| CIS 5.2.x | PCI 2.2 | ISO A.8.22 | NIST AC-6 |
|---|---|---|---|
| securityContext | secure config | segregation | least privilege |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does `runAsNonRoot` do? Why `readOnlyRootFilesystem`? What does `allowPrivilegeEscalation:false` block? **Interview —** *B:* What is a securityContext? *I:* Write a hardened one. *A:* Relationship between securityContext, PSA, seccomp, and capabilities. **Scenario:** app runs as root with writable fs → set non-root + read-only + drop caps, add emptyDir for temp writes, verify it still works.
