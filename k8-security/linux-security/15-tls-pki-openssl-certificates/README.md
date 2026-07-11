# 15 — TLS, PKI, OpenSSL & Certificate Management

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** PCI 4.x, ISO A.8.24, NIST SC-8/SC-12/SC-13

**Objectives:** build a CA & issue certs; understand x509/chains/SAN; choose strong cipher suites; automate rotation; grasp mTLS.

## 1–5. What / why / how
**TLS** provides confidentiality, integrity, and **authentication** in transit via **x509
certificates** issued by a **CA** (PKI trust chain: root→intermediate→leaf). A server proves
identity with a cert (validated against a trusted CA + hostname/**SAN**); **mTLS** adds client
certs so both sides authenticate — the basis of service-mesh identity (K8s module 16) and
zero-trust. **OpenSSL** is the workhorse for keys, CSRs, signing, and inspection.
```
 client ──ClientHello──► server ──cert(chain)──► client verifies: signature+chain+SAN+expiry
 mTLS: client ALSO presents a cert the server verifies (mutual identity)
```

## 6–7. Risks & attacks
- Weak protocols/ciphers (SSLv3/TLS1.0, RC4, no PFS) → MITM/downgrade (POODLE/BEAST/Heartbleed).
- Expired/self-signed/mis-SAN certs → outages or users trained to click through warnings.
- Private key theft (world-readable keys!), weak keys, unbounded cert lifetimes, CA compromise.

## 9–10. Best practices & hardening
- TLS 1.2+ (prefer 1.3), AEAD ciphers, ECDHE (PFS). Keys `600`, never in git.
- Short-lived certs + **automated rotation** (ACME/cert-manager/Vault PKI). Monitor expiry.
- Validate chains/SAN; pin CAs internally; protect the CA (HSM/offline root). CA+cert lab: [examples/make-ca-and-cert.sh](examples/make-ca-and-cert.sh).

## 11. Compliance
| PCI 4.x | ISO A.8.24 | NIST SC-8/12/13 | HIPAA 164.312(e) | GDPR Art.32 |
|---|---|---|---|---|
| strong crypto in transit | cryptography | transmission/key mgmt | transmission security | encryption |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does a CA sign? What is SAN? Why PFS? mTLS vs TLS? **Interview —** *B:* What is TLS? *I:* Issue a server cert + verify chain. *A:* Design PKI + automated rotation for 1000s of services (mesh). **Scenario:** cert expired → outage; fix, then implement automated rotation + expiry monitoring so it never recurs.
