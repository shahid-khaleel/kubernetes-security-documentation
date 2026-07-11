# 09 — Secure Boot & LUKS (Encryption at Rest)

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS 1.x, PCI 3.x, NIST SC-28

**Objectives:** verify boot chain integrity (UEFI Secure Boot/measured boot/TPM); encrypt disks with LUKS2; manage keys & recovery.

## Concept
**Secure Boot** verifies each boot component's signature (firmware→bootloader→kernel) so
malware can't insert a bootkit; **measured boot** extends hashes into the **TPM** (PCRs),
enabling remote attestation and TPM-sealed keys. **LUKS** (dm-crypt) provides **full-disk /
volume encryption at rest**, protecting data if a disk/laptop/backup is stolen — a hard
requirement for PCI/HIPAA on portable or physically-exposed media.

## Risks & attacks
- Unencrypted disk stolen → all data readable (evil-maid, decommissioned-drive leaks).
- Disabled Secure Boot → bootkit/rootkit persistence. Lost LUKS header/passphrase → data loss.
- Weak passphrase/keyslot exposure; keys stored next to data.

## Best practices & hardening
- LUKS2, `aes-xts-plain64`, strong passphrase or TPM-sealed key (`systemd-cryptenroll`).
- **Back up the LUKS header** (`luksHeaderBackup`) — corruption = permanent loss. Escrow recovery keys.
- Keep Secure Boot **on**; sign custom kernels/modules. See [examples/luks-setup.sh](examples/luks-setup.sh).

## Compliance
| PCI 3.x | ISO A.8.24 | NIST SC-28 | HIPAA 164.312(a)(2)(iv) | GDPR Art.32 |
|---|---|---|---|---|
| protect stored data | crypto | data at rest | encryption | encryption |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) (loop device!). **Quiz:** What does Secure Boot verify? Why back up the LUKS header? TPM sealing benefit? **Interview —** *B:* What is FDE? *I:* LUKS setup + recovery strategy. *A:* Boot-to-runtime integrity with TPM attestation. **Scenario:** laptop with PHI stolen → prove LUKS protected it, rotate keys, verify escrow, document for HIPAA breach analysis (encrypted = safe harbor).
