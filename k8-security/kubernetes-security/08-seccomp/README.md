# 08 — Seccomp in Kubernetes

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 5.2.x, NIST SC-39

**Objectives:** apply `RuntimeDefault`; author & deploy custom profiles; use the Security Profiles Operator.

## Concept
**seccomp** (secure computing) filters which **syscalls** a container may make — shrinking the
kernel attack surface (fewer syscalls reachable = fewer exploitable kernel bugs). K8s applies
it via `securityContext.seccompProfile`: **`RuntimeDefault`** (the container runtime's curated
profile blocking ~44 dangerous syscalls) or **`Localhost`** (a custom JSON profile on the
node). The **Security Profiles Operator** can record and manage profiles.

## Risks it reduces
- Kernel exploits via obscure/dangerous syscalls (container escape, T1611). By default pods run
  **`Unconfined`** unless you set a profile — a common gap.

## Best practices & hardening
- Set `seccompProfile: RuntimeDefault` cluster-wide (it's required by PSA `restricted`).
  Example: [examples/pod-seccomp-runtimedefault.yaml](examples/pod-seccomp-runtimedefault.yaml).
- For high-security workloads, author a **least-privilege allowlist** profile ([examples/audit.json](examples/audit.json))
  and deploy via SPO; record real syscalls first to avoid breaking the app.

## Compliance
| CIS 5.2.x | PCI 2.2 | ISO A.8.22 | NIST SC-39 |
|---|---|---|---|
| seccomp enabled | secure config | segregation | process isolation |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does seccomp filter? Default pod profile if unset? RuntimeDefault vs Localhost? **Interview —** *B:* What is seccomp? *I:* Apply RuntimeDefault + verify. *A:* Build a custom profile safely (record→allowlist). **Scenario:** hardening audit finds pods `Unconfined` → set RuntimeDefault via PSA restricted, then pilot a custom profile for the crown-jewel service.
