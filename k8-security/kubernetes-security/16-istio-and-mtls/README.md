# 16 — Istio & mTLS (Service Mesh Security)

> **Track:** Kubernetes Security · **Level:** ⚫ · **Refs:** NIST SC-8/SC-13/AC-4, PCI 4.x

**Objectives:** enforce STRICT mTLS; use AuthorizationPolicy for L7 identity-based authZ; understand mesh identity (SPIFFE).

## Concept
A **service mesh** (Istio/Linkerd) injects a sidecar proxy (Envoy) beside each pod to provide
**automatic mutual TLS** (encryption + **workload identity**), L7 traffic control, and
observability — without app changes. **mTLS** gives every workload a cryptographic identity
(SPIFFE `spiffe://cluster/ns/.../sa/...`) so services authenticate each other; **AuthorizationPolicy**
then allows/denies by identity, method, and path (zero-trust between services).

## Risks it addresses
- Plaintext east-west traffic → sniffing/MITM inside the cluster (T1040). Network-only controls
  can't prove *who* is calling; mesh identity + L7 authZ can. Complements (not replaces) NetworkPolicy.

## Best practices & hardening
- **STRICT** mTLS mesh-wide ([examples/peerauthentication-strict.yaml](examples/peerauthentication-strict.yaml)) —
  reject plaintext. Least-privilege **AuthorizationPolicy** by SA identity ([examples/authorizationpolicy-least-privilege.yaml](examples/authorizationpolicy-least-privilege.yaml)).
- Keep the mesh control plane patched; watch the added attack surface (sidecars/CRDs); default-deny authZ then allow.

## Compliance
| PCI 4.x | ISO A.8.24 | NIST SC-8/AC-4 | HIPAA 164.312(e) |
|---|---|---|---|
| encrypt in transit | cryptography | transmission/flow | transmission security |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does STRICT mTLS enforce? How does a mesh assign identity? mTLS vs NetworkPolicy? **Interview —** *B:* What is a service mesh? *I:* Enforce mTLS + an authZ policy. *A:* Zero-trust east-west design with mesh identity. **Scenario:** PCI requires encrypting internal traffic → deploy Istio, STRICT mTLS, identity-based authZ, verify plaintext is rejected + only authorized SAs can call sensitive services.
