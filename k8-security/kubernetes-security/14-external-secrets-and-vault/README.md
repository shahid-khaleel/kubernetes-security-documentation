# 14 — External Secrets & Vault

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** PCI 3.x/8.x, NIST IA-5/SC-12/SC-28

**Objectives:** externalize secrets to Vault/cloud; use External Secrets Operator & Vault Agent Injector; leverage dynamic secrets.

## Concept
Rather than store secrets in etcd, keep them in a purpose-built store (**HashiCorp Vault**,
AWS/GCP/Azure secret managers) and pull them in. Two patterns: **External Secrets Operator
(ESO)** syncs an external secret into a native K8s Secret (auto-refreshed); **Vault Agent
Injector** side-cars a container that writes secrets to a **tmpfs file** (never in etcd).
Vault also issues **dynamic secrets** (short-lived DB creds minted per request) and **transit
encryption** — a big step beyond static secrets.

## Risks it addresses
- etcd as a single secret honeypot; static long-lived creds; no central rotation/audit.
  Dynamic secrets shrink exposure windows (revoke on lease expiry).

## Best practices & hardening
- Authenticate pods to Vault via **Kubernetes auth** (SA token → Vault role). ESO:
  [examples/externalsecret.yaml](examples/externalsecret.yaml); injector: [examples/vault-agent-injector-annotations.yaml](examples/vault-agent-injector-annotations.yaml).
- Prefer **dynamic secrets** + short TTLs; audit Vault access; least-privilege Vault policies;
  tmpfs (memory) delivery. Combine with encryption at rest (module 13) for any etcd-backed copies.

## Compliance
| PCI 3.x/8.x | ISO A.5.17/8.24 | NIST IA-5/SC-12 | HIPAA 164.312(a) | SOC2 CC6.1 |
|---|---|---|---|---|
| secret protection | secret/key mgmt | authenticator/key | access control | logical access |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** ESO vs Agent Injector? What is a dynamic secret? How do pods auth to Vault? **Interview —** *B:* Why externalize secrets? *I:* Wire ESO to Vault. *A:* Dynamic-secret architecture with rotation + audit. **Scenario:** static DB password shared by many pods leaked → move to Vault dynamic DB creds (per-pod, short TTL), revoke the static one, audit access.
