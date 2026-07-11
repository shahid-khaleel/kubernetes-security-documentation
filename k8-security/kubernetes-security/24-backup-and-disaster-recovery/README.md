# 24 — Backup & Disaster Recovery

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** ISO A.8.13, NIST CP-9/CP-10, PCI (BCP)

**Objectives:** back up etcd + cluster objects + PVs (Velero); define RTO/RPO; secure & test restores; plan ransomware recovery.

## Concept
DR ensures you can **recover the cluster and its data** after failure, corruption, or a
**ransomware/attack** wipe. Two layers: **etcd snapshots** (all cluster state incl. RBAC/secrets)
and **Velero** (namespaced objects + **persistent volume** snapshots, scheduled, with retention).
Define **RTO** (how fast you must be back) and **RPO** (how much data you can lose) and design
backup frequency to meet them. GitOps makes app manifests re-appliable; data needs real backups.

## Risks it addresses
- Ransomware / malicious deletion (T1485/T1486), operator error, region/hardware failure,
  corrupted etcd. **Untested/unsecured backups** are a false sense of safety — and a target
  (encrypt them; isolate credentials).

## Best practices & hardening
- Schedule Velero ([examples/velero-schedule.yaml](examples/velero-schedule.yaml)) + regular **etcd snapshots**
  ([examples/etcd-snapshot.sh](examples/etcd-snapshot.sh)); verify snapshot integrity.
- **Encrypt backups**, store off-cluster/immutable (WORM) so an attacker can't encrypt/delete them;
  **test restores** (DR drills) and measure RTO; separate backup credentials from the cluster.

## Compliance
| ISO A.8.13 | NIST CP-9/CP-10 | PCI 12.10 | HIPAA 164.308(a)(7) | SOC2 A1.2 |
|---|---|---|---|---|
| backup | backup/recovery | BCP | contingency plan | availability |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does an etcd snapshot contain? RTO vs RPO? Why immutable backups? **Interview —** *B:* What to back up in K8s? *I:* Set up Velero + etcd snapshots. *A:* Ransomware-resilient DR design with tested restores. **Scenario:** ransomware encrypted workloads → restore from immutable Velero/etcd backups, verify RTO, confirm attacker couldn't reach the backup store, post-incident harden.
