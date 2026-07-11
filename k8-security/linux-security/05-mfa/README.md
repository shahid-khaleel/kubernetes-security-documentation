# 05 — Multi-Factor Authentication (MFA)

> **Track:** Linux Security · **Level:** 🟡 · **Refs:** CIS 5.x, PCI 8.4/8.5, NIST IA-2(1)

**Objectives:** add TOTP/U2F/FIDO2 to SSH & sudo via PAM; avoid lockout; understand phishing-resistant factors.

## Concept
MFA requires ≥2 of: something you **know** (password), **have** (TOTP app/hardware key),
**are** (biometric). On Linux it's added through **PAM** (module 02): `pam_google_authenticator`
(TOTP), `pam_u2f`/`pam_yubico` (FIDO2/U2F — phishing-resistant). Combined with SSH via
`AuthenticationMethods publickey,keyboard-interactive` = true 2-factor (key + OTP).

## Risks & why it matters
- Single-factor (password or key alone) falls to phishing, key theft, credential stuffing.
- TOTP is phishable/relayable; **FIDO2 hardware keys are phishing-resistant** (origin-bound).
- Misconfig can **lock you out** — always keep a second session + a break-glass path.

## Best practices & hardening
- Enforce MFA on SSH, sudo, and console for all privileged access. Prefer FIDO2 for admins.
- Store TOTP secrets per-user (`~/.google_authenticator`, mode 400). Rate-limit OTP attempts.
- Backup/recovery codes stored securely; document break-glass. See [examples/sshd-mfa-totp.md](examples/sshd-mfa-totp.md).

## Compliance
| PCI 8.4/8.5 | ISO A.5.17 | NIST IA-2(1)(2) | SOC2 CC6.1 | HIPAA 164.312(d) |
|---|---|---|---|---|
| MFA for access | authN info | MFA to privileged | logical access | person/entity authN |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** 3 factor categories? Why FIDO2 > TOTP? How avoid lockout?
**Interview —** *B:* What is MFA? *I:* Add TOTP to SSH without lockout risk. *A:* Roll out phishing-resistant MFA to a fleet + break-glass design. **Scenario:** phishing incident → move admins to FIDO2, enforce `AuthenticationMethods`, revoke shared TOTP, audit who lacks MFA.
