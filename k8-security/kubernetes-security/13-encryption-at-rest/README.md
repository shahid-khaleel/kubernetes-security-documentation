# 13 — Encryption at Rest (etcd)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 2.x, PCI 3.x, NIST SC-28

**Objectives:** configure `EncryptionConfiguration`; use a KMS v2 provider; verify ciphertext in etcd; rotate keys with no downtime.

## Concept
By default, Secrets sit in **etcd as base64 plaintext** — read etcd, read every secret. **Encryption
at rest** encrypts resources (secrets/configmaps) before they hit etcd, via
`--encryption-provider-config`. Providers: `aescbc`/`aesgcm` (local key — better than nothing
but key on disk) and **KMS v2** (envelope encryption — the data key is wrapped by a
**KEK that never leaves an HSM/KMS**; the strong choice).

## Risks it addresses
- etcd disk/backup theft, direct etcd access → mass secret disclosure (T1552). Local-key
  providers still leave the key on the control-plane node (protect it).

## Best practices & hardening
- Use **KMS v2** ([examples/encryption-config-kms.yaml](examples/encryption-config-kms.yaml)); `identity`
  only as read-fallback. **Re-encrypt existing** secrets: `kubectl get secrets -A -o json | kubectl replace -f -`.
- **Verify** ciphertext ([examples/verify-encryption.sh](examples/verify-encryption.sh)); rotate keys by adding
  a new write key, re-encrypting, then removing the old. Encrypt the etcd disk too (defense-in-depth).

## Compliance
| CIS 2.x | PCI 3.x | ISO A.8.24 | NIST SC-28 | HIPAA 164.312(a)(2)(iv) |
|---|---|---|---|---|
| etcd encryption | protect stored data | cryptography | data at rest | encryption |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Are Secrets encrypted in etcd by default? What is envelope encryption? How verify? **Interview —** *B:* Why encrypt etcd? *I:* Configure + verify encryption at rest. *A:* KMS envelope encryption + zero-downtime key rotation. **Scenario:** compliance requires data-at-rest encryption → enable KMS v2, re-encrypt, verify hexdump shows `k8s:enc:kms:`, document rotation runbook.
