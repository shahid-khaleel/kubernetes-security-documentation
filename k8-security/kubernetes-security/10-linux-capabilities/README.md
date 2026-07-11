# 10 — Linux Capabilities in Kubernetes

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 5.2.x, NIST AC-6

**Objectives:** drop ALL capabilities, add back only what's needed, and recognize dangerous caps.

## Concept
**Capabilities** split root's power into ~40 units (Linux module 10 / K8s). Even a non-root
container may hold default caps it doesn't need. In K8s, `securityContext.capabilities`
controls them: **drop `ALL`**, then `add` only the minimum (e.g. `NET_BIND_SERVICE` to bind
<1024). This limits what a compromised process can do without a full escape.

## Risks & attacks
- Dangerous caps enable escapes/abuse: **`SYS_ADMIN`** (the "new root" — mounts, namespaces),
  `SYS_MODULE` (load kernel modules → own the host), `SYS_PTRACE`, `NET_ADMIN`, `NET_RAW`
  (spoofing), `DAC_OVERRIDE`/`DAC_READ_SEARCH` (bypass file perms). See [examples/dangerous-caps-reference.md](examples/dangerous-caps-reference.md).

## Best practices & hardening
- `drop: ["ALL"]` + minimal `add` ([examples/pod-drop-all-add-one.yaml](examples/pod-drop-all-add-one.yaml)).
  Required by PSA `restricted`. Never add `SYS_ADMIN`/`SYS_MODULE`; audit `add:` lists cluster-wide.
- Prefer capabilities over `--privileged`; combine with seccomp + non-root.

## Compliance
| CIS 5.2.x | PCI 2.2 | ISO A.8.22 | NIST AC-6 |
|---|---|---|---|
| drop capabilities | secure config | segregation | least privilege |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Which cap binds low ports? Why is `SYS_ADMIN` dangerous? Default vs dropped caps? **Interview —** *B:* What are capabilities? *I:* Configure drop-ALL-add-one. *A:* Audit and eliminate dangerous caps at scale. **Scenario:** a workload requests `SYS_ADMIN` "for mounts" → find the real need, replace with a targeted approach or CSI, drop ALL else, block `SYS_ADMIN` at admission.
