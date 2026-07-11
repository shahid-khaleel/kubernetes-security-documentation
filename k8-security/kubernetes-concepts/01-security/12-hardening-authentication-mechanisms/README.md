# Hardening Guide — Authentication Mechanisms

**What it is.** The official guidance on choosing and hardening K8s authentication:
X.509 client certs, static tokens (avoid), bootstrap tokens, ServiceAccount tokens, and
**OIDC** for humans.

**Why it matters.** Weak/long-lived credentials are the most common initial-access vector.
Certs can't be easily revoked; static token files are plaintext; OIDC + MFA is the strong path.

**Guidance**
| Mechanism | Use for | Cautions |
|---|---|---|
| **OIDC** | human users (SSO+MFA) | validate issuer; map groups to RBAC; short token TTL |
| **ServiceAccount (bound) tokens** | workloads/automation | audience-bound, short-lived; disable automount |
| **X.509 client certs** | bootstrap/break-glass | no revocation (CRL) — keep short-lived, guard the CA |
| **Static token/basic auth files** | ❌ avoid | plaintext, no expiry — removed/deprecated |

**Best practices:** disable anonymous auth; no static tokens; OIDC+MFA for people; bound
tokens for pods; rotate/revoke on offboarding via the IdP; guard `system:masters` certs.
**Cross-links:** [security/03 — Authentication](../../../kubernetes-security/03-authentication/), [Controlling API Access](../08-controlling-access-to-the-api/).
