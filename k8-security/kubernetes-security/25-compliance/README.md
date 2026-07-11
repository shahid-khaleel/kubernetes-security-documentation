# 25 — Compliance (K8s)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS, PCI DSS, HIPAA, SOC 2, ISO 27001, NIST

**Objectives:** map platform controls to frameworks; automate evidence collection; run continuous compliance.

## Concept
Compliance translates security controls into **auditable evidence** against frameworks
(PCI/HIPAA/SOC2/ISO/CIS). In Kubernetes this means mapping each requirement to the concrete
control (RBAC, encryption, NetworkPolicy, audit logs, image scanning) and **automating evidence**
so audits are continuous, not fire-drills. See [examples/pci-control-to-k8s-mapping.md](examples/pci-control-to-k8s-mapping.md)
and the cross-track [compliance matrix](../../resources/compliance-matrix.md).

## Risks it addresses
- Failed audits, fines, and — more importantly — the security gaps that failing controls
  represent. Point-in-time compliance that silently drifts between audits.

## Best practices & hardening
- **Control-to-evidence matrix**: for each control, name the K8s mechanism + the automated
  evidence (kube-bench JSON, kubescape, Trivy reports, audit-log samples, Velero reports).
- Wire evidence generation into **CI** (regenerate on every merge); track exceptions with
  justification+expiry; use policy engines (05) to *enforce*, not just detect.

## Compliance
| CIS | PCI DSS 4.0 | HIPAA | SOC 2 | ISO 27001 | NIST 800-190/53 |
|---|---|---|---|---|---|
| benchmark | full mapping | ePHI | TSC | ISMS | container/controls |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What is a control-to-evidence matrix? How automate evidence? Detect vs enforce? **Interview —** *B:* Which frameworks apply to K8s? *I:* Map 5 PCI reqs to K8s controls. *A:* Build continuous-compliance with automated evidence + enforcement. **Scenario:** PCI audit in 30 days → build the mapping, automate kube-bench/kubescape/Trivy evidence, remediate gaps, enforce via admission, produce the evidence pack.
