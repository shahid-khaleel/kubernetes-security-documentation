# 21 — Cluster Hardening (CIS & NSA/CISA)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s Benchmark, NSA/CISA Hardening Guide

**Objectives:** apply the CIS Benchmark + NSA/CISA guide as a coherent hardening program; measure and track posture.

## Concept
This module **ties the track together** into a repeatable hardening program. The **CIS
Kubernetes Benchmark** is the prescriptive checklist (control plane, etcd, kubelet, policies,
RBAC); the **NSA/CISA Kubernetes Hardening Guide** is the strategic companion (non-root/immutable
workloads, network separation, authN/authZ, logging, upgrades). Together they define "what good
looks like" — measured continuously (module 22), not once.

## Risks it addresses
- Default-open configs, drift over time, inconsistent hardening across clusters, unpatched
  components — the accumulation of small gaps that enable a breach.

## Best practices & hardening
- Work the NSA checklist ([examples/nsa-hardening-checklist.md](examples/nsa-hardening-checklist.md)): non-root +
  immutable + drop caps, PSA restricted (06), default-deny network (15), encrypt etcd (13),
  least-priv RBAC (04), audit logging (20), image scanning + signing (17), runtime detection (19),
  patch cadence, disable anonymous auth (02/03).
- **Measure** with kube-bench/kubescape (22); track score over time; enforce via admission (05).

## Compliance
| CIS K8s | NSA/CISA | PCI 2.2 | ISO A.8.9 | NIST CM-6 |
|---|---|---|---|---|
| benchmark | hardening guide | secure config | config mgmt | config settings |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** CIS vs NSA guide? Name five hardening controls. Why measure continuously? **Interview —** *B:* What is the CIS K8s benchmark? *I:* Walk a hardening pass. *A:* Build a continuous cluster-hardening program with drift detection. **Scenario:** new cluster to production-harden → run kube-bench baseline, work CIS+NSA, re-score, wire scanning into CI, set a posture SLO.
