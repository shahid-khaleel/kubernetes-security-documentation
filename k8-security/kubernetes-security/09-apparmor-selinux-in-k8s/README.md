# 09 — AppArmor & SELinux in Kubernetes

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s, NIST AC-3/SC-39

**Objectives:** apply per-container AppArmor profiles and SELinux MCS options for MAC confinement.

## Concept
These bring **Mandatory Access Control** (Linux modules 06/07) to pods. **AppArmor** profiles
(loaded on the node) confine a container's file/capability/network access via
`securityContext.appArmorProfile` (field since 1.30; annotation before). **SELinux** applies
type + **MCS category** labels via `seLinuxOptions` — unique categories per workload/tenant
give strong isolation on RHEL/OpenShift nodes. MAC confines even a root-in-container process.

## Risks it reduces
- A compromised container reading/writing beyond its need, escalating, or touching host paths.
  Adds a layer that survives even if DAC/caps are misconfigured.

## Best practices & hardening
- **Load profiles on every node** (DaemonSet/`apparmor_parser`) before referencing them.
  AppArmor: [examples/pod-apparmor.yaml](examples/pod-apparmor.yaml); SELinux MCS: [examples/pod-selinux-options.yaml](examples/pod-selinux-options.yaml).
- Deny writes to binaries/`/etc/shadow`; unique MCS per tenant (multi-tenancy, module 23).
  Manage at scale with the Security Profiles Operator.

## Compliance
| CIS K8s | PCI 2.2 | ISO A.8.22 | NIST AC-3/SC-39 |
|---|---|---|---|
| MAC confinement | secure config | segregation | mandatory access |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Where must AppArmor profiles be loaded? What are MCS categories for? MAC vs seccomp? **Interview —** *B:* AppArmor vs SELinux in K8s? *I:* Apply a deny-write profile to a pod. *A:* Per-tenant MAC isolation strategy. **Scenario:** multi-tenant cluster needs stronger isolation → assign unique SELinux MCS per tenant + AppArmor deny profiles, load via DaemonSet, verify cross-tenant access is blocked.
