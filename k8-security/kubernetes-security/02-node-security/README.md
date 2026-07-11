# 02 — Node Security (Kubelet)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 4.x, NSA/CISA, NIST AC-3

**Objectives:** harden the kubelet (authN/authZ, read-only port), isolate nodes, apply Node authorizer + NodeRestriction.

## Concept
Each worker runs a **kubelet** that manages pods and exposes an API (`:10250`). If it allows
**anonymous auth** or **`AlwaysAllow`** authZ, anyone reaching it can `exec` into pods and
read data on that node. The legacy **read-only port `:10255`** leaks pod info unauthenticated.
Nodes also carry every mounted Secret of pods scheduled there — node compromise is serious.

## Risks & attacks
- `--anonymous-auth=true` / authZ `AlwaysAllow` → kubelet takeover, pod exec, secret theft (T1078).
- Read-only port `:10255` open → recon. A compromised node reading other nodes' secrets if
  Node authorizer/NodeRestriction not enforced.

## Best practices & hardening (CIS 4.2.x)
- Kubelet config ([examples/kubelet-config-hardened.yaml](examples/kubelet-config-hardened.yaml)):
  `anonymous.enabled=false`, `authorization.mode=Webhook`, `readOnlyPort=0`,
  `protectKernelDefaults=true`, strong `tlsCipherSuites`, `rotateCertificates=true`.
- Enable **NodeRestriction** admission + **Node authorizer**; harden the node OS (Linux track);
  minimize what runs on nodes; auto-rotate node certs.

## Compliance
| CIS 4.x | PCI 2.2 | ISO A.8.22 | NIST AC-3/SC-7 |
|---|---|---|---|
| kubelet config | secure config | segregation | access/boundary |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What port is the kubelet? Why disable `:10255`? What does NodeRestriction do? **Interview —** *B:* What is the kubelet? *I:* Harden kubelet authN/authZ. *A:* Contain a compromised node's blast radius. **Scenario:** kubelet `:10250` allowed anonymous → attacker `exec`'d pods; disable anon auth, set Webhook authZ, close `:10255`, rotate node creds + affected secrets.
