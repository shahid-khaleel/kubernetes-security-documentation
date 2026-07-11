# 📘 Kubernetes Concepts & Hardening (Official-Docs Aligned)

A companion to the [Kubernetes Security track](../kubernetes-security/) that mirrors the
**official Kubernetes documentation** concept tree — Security, Policies, Scheduling/
Preemption/Eviction, Cluster Administration, Observability, Windows, and Extending
Kubernetes — every topic written **through a security lens** with runnable examples.

> Where a topic overlaps a deep module in the main security track, this page gives the
> concept + examples and **cross-links** to the deep dive (e.g. Pod Security Admission →
> [security/06](../kubernetes-security/06-pod-security-admission/)).

Each topic folder has a `README.md` (concept · why it matters for security · example ·
best practices · cross-links) and, where a manifest is natural, an `examples/` file.

---

## 01 · [Security](01-security/)
| # | Topic | Cross-link |
|---|-------|-----------|
| 01 | [Cloud Native Security (4 C's)](01-security/01-cloud-native-security-4c/) | track overview |
| 02 | [Pod Security Standards](01-security/02-pod-security-standards/) | [sec/06](../kubernetes-security/06-pod-security-admission/) |
| 03 | [Pod Security Admission](01-security/03-pod-security-admission/) | [sec/06](../kubernetes-security/06-pod-security-admission/) |
| 04 | [Service Accounts](01-security/04-service-accounts/) | [sec/11](../kubernetes-security/11-service-accounts/) |
| 05 | [Pod Security Policies (legacy)](01-security/05-pod-security-policies-legacy/) | historical |
| 06 | [Security for Linux Nodes](01-security/06-security-for-linux-nodes/) | [Linux track](../linux-security/) |
| 07 | [Security for Windows Nodes](01-security/07-security-for-windows-nodes/) | [win](06-windows/) |
| 08 | [Controlling Access to the K8s API](01-security/08-controlling-access-to-the-api/) | [sec/03](../kubernetes-security/03-authentication/),[04](../kubernetes-security/04-authorization-rbac/) |
| 09 | [RBAC Good Practices](01-security/09-rbac-good-practices/) | [sec/04](../kubernetes-security/04-authorization-rbac/) |
| 10 | [Secrets Good Practices](01-security/10-secrets-good-practices/) | [sec/12](../kubernetes-security/12-secrets-management/) |
| 11 | [Multi-tenancy](01-security/11-multi-tenancy/) | [sec/23](../kubernetes-security/23-multi-tenancy/) |
| 12 | [Hardening — Authentication Mechanisms](01-security/12-hardening-authentication-mechanisms/) | [sec/03](../kubernetes-security/03-authentication/) |
| 13 | [Hardening — Dynamic Resource Allocation](01-security/13-hardening-dynamic-resource-allocation/) | [sch/09](03-scheduling-preemption-eviction/09-dynamic-resource-allocation/) |
| 14 | [Hardening — Scheduler Configuration](01-security/14-hardening-scheduler-configuration/) | [sch/01](03-scheduling-preemption-eviction/01-kubernetes-scheduler/) |
| 15 | [API Server Bypass Risks](01-security/15-api-server-bypass-risks/) | [sec/02](../kubernetes-security/02-node-security/) |
| 16 | [Linux Kernel Security Constraints for Pods](01-security/16-linux-kernel-security-constraints/) | [sec/07-10](../kubernetes-security/07-security-contexts/) |
| 17 | [Security Checklist](01-security/17-security-checklist/) | whole track |
| 18 | [Application Security Checklist](01-security/18-application-security-checklist/) | whole track |

## 02 · [Policies](02-policies/)
[Limit Ranges](02-policies/01-limit-ranges/) · [Resource Quotas](02-policies/02-resource-quotas/) · [Process ID Limits & Reservations](02-policies/03-process-id-limits-and-reservations/)

## 03 · [Scheduling, Preemption & Eviction](03-scheduling-preemption-eviction/)
[Scheduler](03-scheduling-preemption-eviction/01-kubernetes-scheduler/) · [Topology-Aware Scheduling](03-scheduling-preemption-eviction/02-topology-aware-workload-scheduling/) · [Assigning Pods to Nodes](03-scheduling-preemption-eviction/03-assigning-pods-to-nodes/) · [Pod Overhead](03-scheduling-preemption-eviction/04-pod-overhead/) · [Scheduling Readiness](03-scheduling-preemption-eviction/05-pod-scheduling-readiness/) · [Topology Spread](03-scheduling-preemption-eviction/06-pod-topology-spread-constraints/) · [Taints & Tolerations](03-scheduling-preemption-eviction/07-taints-and-tolerations/) · [Scheduling Framework](03-scheduling-preemption-eviction/08-scheduling-framework/) · [Dynamic Resource Allocation](03-scheduling-preemption-eviction/09-dynamic-resource-allocation/) · [Gang Scheduling](03-scheduling-preemption-eviction/10-gang-scheduling/) · [Scheduler Perf Tuning](03-scheduling-preemption-eviction/11-scheduler-performance-tuning/) · [PodGroup Scheduling](03-scheduling-preemption-eviction/12-podgroup-scheduling/) · [Resource Bin Packing](03-scheduling-preemption-eviction/13-resource-bin-packing/) · [Workload-Aware Preemption](03-scheduling-preemption-eviction/14-workload-aware-preemption/) · [Priority & Preemption](03-scheduling-preemption-eviction/15-pod-priority-and-preemption/) · [Node-pressure Eviction](03-scheduling-preemption-eviction/16-node-pressure-eviction/) · [API-initiated Eviction](03-scheduling-preemption-eviction/17-api-initiated-eviction/) · [Node Declared Features](03-scheduling-preemption-eviction/18-node-declared-features/)

## 04 · [Cluster Administration](04-cluster-administration/)
[Node Shutdowns](04-cluster-administration/01-node-shutdowns/) · [Swap Memory](04-cluster-administration/02-swap-memory-management/) · [Node Autoscaling](04-cluster-administration/03-node-autoscaling/) · [Certificates](04-cluster-administration/04-certificates/) · [Cluster Networking](04-cluster-administration/05-cluster-networking/)

## 05 · [Observability](05-observability/)
[Admission Webhook Good Practices](05-observability/01-admission-webhook-good-practices/) · [DRA Good Practices (Admin)](05-observability/02-dra-good-practices-cluster-admin/) · [Logging Architecture](05-observability/03-logging-architecture/) · [Compatibility Version](05-observability/04-compatibility-version-control-plane/) · [Metrics — System Components](05-observability/05-metrics-for-system-components/) · [Metrics — Object States](05-observability/06-metrics-for-object-states/) · [System Logs](05-observability/07-system-logs/) · [Traces](05-observability/08-traces-for-system-components/) · [Proxies](05-observability/09-proxies-in-kubernetes/) · [API Priority & Fairness](05-observability/10-api-priority-and-fairness/) · [Installing Addons](05-observability/11-installing-addons/) · [Coordinated Leader Election](05-observability/12-coordinated-leader-election/)

## 06 · [Windows in Kubernetes](06-windows/)
[Windows Containers](06-windows/01-windows-containers-in-kubernetes/) · [Running Windows Containers — Guide](06-windows/02-guide-running-windows-containers/)

## 07 · [Extending Kubernetes](07-extending-kubernetes/)
[Compute/Storage/Networking Extensions](07-extending-kubernetes/01-compute-storage-networking-extensions/) · [Extending the K8s API (CRDs/Aggregation)](07-extending-kubernetes/02-extending-the-kubernetes-api/) · [Operator Pattern](07-extending-kubernetes/03-operator-pattern/)

---
**Legend:** every README answers *what it is · why it matters for security · example ·
best practices · cross-links*. Manifest-heavy topics ship an `examples/` file.
