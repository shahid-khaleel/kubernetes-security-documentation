# 06 — Pod Security Admission (PSA)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 5.2.x, NSA/CISA, NIST CM-7

**Objectives:** enforce Pod Security Standards (privileged/baseline/restricted) via namespace labels; migrate off PSP.

## Concept
**PSA** is the built-in (GA 1.25) replacement for the removed PodSecurityPolicy. It enforces
three **Pod Security Standards** at the namespace level via labels:
**privileged** (unrestricted), **baseline** (blocks the well-known bad: privileged, hostPath,
hostNetwork, added dangerous caps), **restricted** (hardened: runAsNonRoot, drop ALL caps,
seccomp RuntimeDefault, no privilege escalation, readOnlyRootFilesystem-friendly). Three
**modes**: `enforce` (block), `audit` (log), `warn` (user warning).

## Risks it addresses
- Root/privileged/hostPath pods → container escape & node compromise (T1611). PSA makes
  "restricted" the default guardrail so a compromised RBAC identity still can't run a dangerous pod.

## Best practices & hardening
- Label namespaces `pod-security.kubernetes.io/enforce: restricted`
  ([examples/namespace-psa-restricted.yaml](examples/namespace-psa-restricted.yaml)); pin `enforce-version`.
- Use `warn`/`audit` first to find violations; golden compliant pod: [examples/restricted-compliant-pod.yaml](examples/restricted-compliant-pod.yaml).
- PSA is namespace-coarse; use **Kyverno/Gatekeeper** (module 05) for finer/exception policy.

## Compliance
| CIS 5.2.x | PCI 2.2 | ISO A.8.22 | NIST CM-7 | NSA/CISA |
|---|---|---|---|---|
| PSA restricted | secure config | segregation | least functionality | non-root/immutable |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Three standards? Three modes? What does restricted require? **Interview —** *B:* What replaced PSP? *I:* Enforce restricted on a namespace + fix a failing pod. *A:* Migrate a cluster to restricted with exceptions. **Scenario:** new policy: no root pods cluster-wide → label all namespaces restricted (warn first), fix violating workloads, then enforce, back with an admission policy for edge cases.
