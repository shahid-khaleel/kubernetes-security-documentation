# 11 — Service Accounts (Token Hygiene)

> **Track:** Kubernetes Security · **Level:** 🟡 · **Refs:** CIS K8s 5.1.5/5.1.6, NIST AC-2/IA-2

**Objectives:** disable unneeded token automount; use bound/projected tokens; scope SA identity for pods.

## Concept
A **ServiceAccount (SA)** is a pod's identity to the API server, carrying a **token** (JWT).
Historically K8s auto-mounted a **long-lived** token into every pod at
`/var/run/secrets/kubernetes.io/serviceaccount/` — a juicy target. Modern K8s uses
**bound service account tokens**: short-lived, **audience-bound**, auto-rotated, projected via
volume. Combined with RBAC (module 04), the SA defines a pod's blast radius if compromised.

## Risks & attacks
- **Token theft** from a compromised pod → use its RBAC to pivot (T1078/T1528). The `default`
  SA is mounted everywhere; if it has rights, every pod inherits them. Long-lived tokens don't expire.

## Best practices & hardening
- `automountServiceAccountToken: false` by default; opt-in only where the API is truly called.
  Use **projected bound tokens** (short TTL + audience). See [examples/sa-no-automount-and-bound-token.yaml](examples/sa-no-automount-and-bound-token.yaml).
- Dedicated SA per workload with least-privilege RBAC (never `default` for real apps). Rotate on incident.

## Compliance
| CIS 5.1.5/5.1.6 | PCI 7.x/8.x | ISO A.5.16 | NIST AC-2/IA-2 |
|---|---|---|---|
| SA token hygiene | least priv/identity | identity mgmt | account/authN |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Where is the SA token mounted? What is a bound token? Why avoid the `default` SA? **Interview —** *B:* What is a ServiceAccount? *I:* Disable automount + use a bound token. *A:* Limit blast radius of a stolen SA token. **Scenario:** SA token exfiltrated from a pod → rotate it, scope its RBAC + `resourceNames`, disable automount, switch to bound tokens, add audit alert on cross-namespace access.
