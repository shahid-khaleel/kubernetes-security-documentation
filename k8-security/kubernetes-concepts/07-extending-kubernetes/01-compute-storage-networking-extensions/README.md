# Compute, Storage & Networking Extensions

**What it is.** Standard interfaces to plug third-party implementations into K8s:
- **CRI** (Container Runtime Interface) — containerd/CRO-O, sandboxed runtimes via RuntimeClass.
- **CSI** (Container Storage Interface) — storage drivers (block/file/object).
- **CNI** (Container Network Interface) — pod networking + NetworkPolicy (Calico/Cilium).
- **Device plugins / DRA** — GPUs/FPGAs/NICs.

**Why it matters (security).** These plugins run **privileged** (host mounts, node network,
device access) — they are high-value **supply-chain** targets and privilege-escalation surface.
A malicious CSI/CNI driver can read any volume or reroute traffic; a bad runtime can escape.

**Security per interface**
| Interface | Risk | Control |
|---|---|---|
| **CRI/RuntimeClass** | runtime escape | patch runc; gVisor/Kata for untrusted ([docker/04](../../../docker-security/04-containerd-runc/)) |
| **CSI** | read/tamper volumes | vet/sign driver; least-priv RBAC; encrypt volumes |
| **CNI** | traffic sniff/reroute; policy bypass | trusted CNI; verify policy enforcement |
| **Device plugin/DRA** | device escape/side-channel | vet driver; restrict claims ([DRA](../../03-scheduling-preemption-eviction/09-dynamic-resource-allocation/)) |

**Best practices:** treat all as privileged addons ([Installing Addons](../../05-observability/11-installing-addons/)); pin/scan/sign; least-privilege RBAC; keep patched.
**Cross-links:** [Cluster Networking](../../04-cluster-administration/05-cluster-networking/), [Operator Pattern](../03-operator-pattern/).
