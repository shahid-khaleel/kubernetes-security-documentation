# 03 — Authentication

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 3.x, NSA/CISA, NIST IA-2

**Objectives:** understand client certs, OIDC, and ServiceAccount tokens; manage kubeconfig; prefer short-lived, IdP-backed identities.

## 1–5. Concept
Kubernetes **has no user database** — it authenticates via pluggable methods and hands the
resulting **username + groups** to authorization (RBAC, module 04). Methods: **X.509 client
certs** (CN=user, O=group — hard to revoke, avoid at scale), **OIDC** (enterprise SSO —
Okta/Azure AD/Keycloak; groups map to RBAC — the recommended human path), **ServiceAccount
tokens** (JWTs for pods/automation — now short-lived, audience-bound *bound tokens*).
`kubeconfig` bundles the endpoint + identity credential.

## 6–7. Risks & attacks
- **Long-lived/leaked kubeconfigs or SA tokens** → account takeover (T1078). Client certs can't
  be easily revoked (no CRL) → rotation pain. Anonymous auth enabled. Shared human creds.
- Tokens in git/CI logs; over-long token TTLs; no MFA on the IdP.

## 9–10. Best practices & hardening
- **OIDC + MFA** for humans, group-based; **bound SA tokens** (short TTL, audience) for
  workloads (module 11). Certs only for bootstrap/break-glass; short validity.
  See [examples/oidc-apiserver-flags.md](examples/oidc-apiserver-flags.md), [examples/generate-user-cert.sh](examples/generate-user-cert.sh).
- Disable anonymous auth; never store creds in git; rotate/revoke on offboarding (one IdP change).

## 11. Compliance
| CIS 3.x | PCI 8.x | ISO A.5.16/17 | NIST IA-2 | HIPAA 164.312(d) |
|---|---|---|---|---|
| authN config | identify users/MFA | identity/authN | user authN | person/entity authN |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Does K8s store users? How does a cert convey a group? Why OIDC over certs? What is a bound token? **Interview —** *B:* K8s auth methods? *I:* Set up OIDC + map groups to RBAC. *A:* Design identity for humans + workloads with revocation. **Scenario:** a kubeconfig leaked → revoke (rotate CA or IdP session), move to OIDC+MFA, shorten token TTLs, audit for other long-lived creds.
