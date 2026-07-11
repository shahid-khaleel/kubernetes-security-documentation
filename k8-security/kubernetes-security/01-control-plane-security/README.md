# 01 — Control Plane Security

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 1.x/2.x, NSA/CISA, NIST SC-7/SC-28

**Objectives:** harden apiserver/etcd/scheduler/controller-manager; enable etcd encryption + TLS; lock down the "crown jewels".

## 1–5. Concept & architecture
The **control plane** is the cluster's brain: **kube-apiserver** (the single front door —
authN/authZ/admission), **etcd** (key-value store holding *all* state incl. **Secrets**),
**scheduler**, and **controller-manager**. Compromise here = compromise everything.
```
 kubectl/pods ─► kube-apiserver ─► etcd (ALL state, incl secrets)
                    │  scheduler / controller-manager (via apiserver)
 Secure: TLS on every hop, apiserver auth flags, etcd encryption + mTLS + peer certs
```

## 6–7. Risks & attacks
- **Unauthenticated apiserver** (`--anonymous-auth=true`) or `--authorization-mode=AlwaysAllow`.
- **etcd exposure** — anyone who reads etcd reads every Secret in plaintext (unless encrypted).
  Direct etcd access bypasses RBAC entirely (T1552/T1078).
- Insecure ports, weak TLS, exposed apiserver to the internet, profiling enabled.

## 9–10. Best practices & hardening (CIS 1.x)
- `--anonymous-auth=false`, `--authorization-mode=Node,RBAC`, `--profiling=false`, TLS 1.2+,
  admission plugins (NodeRestriction, PodSecurity). See [examples/kube-apiserver-hardened-flags.yaml](examples/kube-apiserver-hardened-flags.yaml).
- **Encrypt Secrets at rest** ([examples/etcd-encryption-config.yaml](examples/etcd-encryption-config.yaml), module 13);
  **etcd mTLS + peer auth**, restrict etcd to control-plane nodes, encrypt its disk.
- Firewall the API; private endpoint; validate with kube-bench (module 22).

## 11. Compliance
| CIS 1.x/2.x | PCI 2.2/4.x | ISO A.8.9 | NIST SC-7/SC-28 | NSA/CISA |
|---|---|---|---|---|
| control-plane flags | secure config/transit | config mgmt | boundary/at-rest | apiserver+etcd hardening |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does etcd hold? Why encrypt it? Effect of `AlwaysAllow`? **Interview —** *B:* Name control-plane components. *I:* Which apiserver flags harden it? *A:* Threat-model the control plane (STRIDE) + etcd protection. **Scenario:** etcd found reachable from a worker → restrict to control plane, enable encryption+mTLS, rotate all secrets, re-run kube-bench.
