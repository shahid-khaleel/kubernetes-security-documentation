# 🧭 Compliance Coverage Matrix

How the curriculum's controls map to the major frameworks. Use this to (a) study for
audits, (b) answer "which control satisfies requirement X?", (c) build evidence packs.

## Framework primer (what each is / who cares)
| Framework | What it is | Applies to |
|-----------|------------|-----------|
| **CIS Benchmarks** | Prescriptive hardening checklists (Linux, Docker, Kubernetes) | Everyone; the baseline |
| **PCI DSS 4.0** | Payment card data protection | Fintech, banking, any card processing |
| **ISO/IEC 27001** | ISMS — risk-based security management | Global enterprises |
| **SOC 2** | Trust Services Criteria (security/availability/confidentiality) | SaaS / cloud vendors |
| **NIST 800-53** | US federal control catalog | Gov + regulated industry |
| **NIST 800-190** | Application container security guide | Container platforms specifically |
| **HIPAA** | US health data (ePHI) safeguards | Healthcare |
| **GDPR** | EU personal-data protection | Anyone with EU data subjects |
| **DISA STIG** | DoD hardening standards | US defense/gov |
| **SLSA** | Supply-chain integrity levels (1–4) | Build/CI provenance |

## Control → module map (condensed)
| Control theme | CIS | PCI | ISO 27001 | SOC 2 | NIST 800-53 | HIPAA | Modules |
|---------------|-----|-----|-----------|-------|-------------|-------|---------|
| Least-privilege access | Linux 1/6, K8s 5.1 | 7.x | A.5.15 | CC6.1 | AC-6 | 164.312(a) | LNX01/04, K8s04/11 |
| Strong authN + MFA | 5.2/5.4 | 8.x | A.5.16 | CC6.1 | IA-2 | 164.312(d) | LNX02/03/05, K8s03 |
| MAC / workload isolation | — | 2.2 | A.8.22 | CC6.6 | AC-3, SC-7 | 164.308 | LNX06/07, K8s07-10 |
| Encryption at rest | 1.1 (crypt) | 3.x | A.8.24 | CC6.7 | SC-28 | 164.312(a)(2) | LNX09, K8s13 |
| Encryption in transit | 2.x | 4.x | A.8.24 | CC6.7 | SC-8 | 164.312(e) | LNX15, K8s16 |
| Network segmentation | firewall | 1.x | A.8.20/22 | CC6.6 | SC-7 | 164.312(e) | LNX11, K8s15/23 |
| Vuln mgmt / scanning | — | 6.x/11.x | A.8.8 | CC7.1 | RA-5 | 164.308(a)(1) | DKR09, K8s17/22 |
| Supply-chain integrity | — | 6.3 | A.8.30 | CC8.1 | SR-3/4/11 | — | DKR14, K8s17/18 |
| Audit logging + review | 4.x (auditd) | 10.x | A.8.15 | CC7.2 | AU-2/6/12 | 164.312(b) | LNX12, K8s20 |
| Runtime threat detection | — | 11.5 | A.8.16 | CC7.2 | SI-4 | 164.308(a)(6) | K8s19 |
| Backup / DR | — | — | A.8.13 | A1.2 | CP-9/10 | 164.308(a)(7) | K8s24, LNX17 |
| Config/change mgmt | all | 6.5 | A.8.32 | CC8.1 | CM-3/5 | 164.308(a)(8) | K8s05/21, LNX16 |
| Incident response | — | 12.10 | A.5.24-27 | CC7.3-5 | IR-4/5/6 | 164.308(a)(6) | LNX17, K8s26, DKR15 |

## Evidence automation (what to collect, per framework audit)
- **kube-bench** JSON → CIS Kubernetes control evidence.
- **Lynis / OpenSCAP** → CIS/STIG Linux evidence + score.
- **Trivy / Grype** reports → vuln-management (PCI 6/11, SOC2 CC7).
- **kubescape** (NSA/MITRE frameworks) → posture evidence.
- **audit logs → SIEM** with retention proof → logging controls (PCI 10, HIPAA 164.312(b)).
- **Velero backup reports** → DR/CP evidence.
- **cosign verify** logs → supply-chain (SLSA, SR controls).

> Retention rule-of-thumb: PCI ≥ 1 year (90 days hot), HIPAA ≥ 6 years, SOC2 per policy.
> Store logs in WORM/immutable storage so an attacker who gains root can't erase evidence.
