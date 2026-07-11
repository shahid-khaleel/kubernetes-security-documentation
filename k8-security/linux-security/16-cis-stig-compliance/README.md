# 16 — CIS & STIG Compliance (Linux)

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS Benchmarks, DISA STIG, NIST CM-6

**Objectives:** run OpenSCAP/Lynis against CIS/STIG profiles; interpret & remediate findings; automate evidence.

## Concept
**CIS Benchmarks** and **DISA STIGs** are prescriptive, versioned hardening standards for
specific OSes. **OpenSCAP** (`oscap`) evaluates a host against a machine-readable profile
(SCAP datastream), produces a scored report, and can generate **remediation** scripts/Ansible.
This turns "are we hardened?" into a measurable, repeatable, auditable control — the backbone
of continuous compliance.

## Risks & why it matters
- Config drift reintroduces weaknesses over time. Manual hardening is inconsistent across a fleet.
- Auditors require **evidence**; ad-hoc claims fail. Blind remediation can break apps — test first.

## Best practices & hardening
- Bake a hardened **golden image** (CIS Level 1/2), then continuously scan for drift.
- Automate: OpenSCAP/Lynis in CI + scheduled; store reports as evidence. See [examples/openscap-scan.sh](examples/openscap-scan.sh).
- Track exceptions with justification + expiry. Map findings to control IDs for audits.

## Compliance
| CIS | STIG | ISO A.8.9 | NIST CM-6 | PCI 2.2 |
|---|---|---|---|---|
| benchmark | DoD hardening | config mgmt | config settings | secure baselines |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** CIS vs STIG? What does oscap produce? Why golden images? **Interview —** *B:* What is a CIS benchmark? *I:* Run + interpret an OpenSCAP scan. *A:* Continuous-compliance pipeline with evidence + exception mgmt. **Scenario:** audit next month → scan fleet, remediate top failures (test first), generate control-mapped evidence, set up drift detection.
