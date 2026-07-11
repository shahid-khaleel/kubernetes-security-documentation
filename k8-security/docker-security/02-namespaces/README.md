# 02 — Namespaces (Container Isolation, Part 1)

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** NIST 800-190, CIS Docker 5.x

**Objectives:** explain each namespace; understand user-namespace remapping; know which host-namespace shares break isolation.

## Concept
**Namespaces** are the kernel feature that gives a container its *own view* of a global
resource. The 7 types: **pid** (process tree), **net** (interfaces/ports), **mnt**
(filesystem mounts), **uts** (hostname), **ipc** (shared memory/queues), **user** (uid/gid
mapping), **cgroup** (cgroup root). A container is just processes with these namespaces
unshared. The **user namespace** is special: it can map container **uid 0 → an unprivileged
host uid**, so "root in the container" isn't root on the host (foundation of rootless).

## Risks & attacks
- **Host namespace sharing** breaks isolation: `--pid=host` (see/kill host procs),
  `--net=host` (host network, no isolation), `--ipc=host`, sharing `/proc` or the mnt ns.
- **Without user-namespace remap**, container root == host root on mounted files/devices →
  a bind-mounted host path is writable as root (escape vector, T1611).
- Namespaces isolate *view*, not the *kernel* — a kernel exploit ignores them.

## Best practices & hardening
- Never use host namespaces for untrusted workloads. Enable **userns-remap**
  ([examples/daemon-userns-remap.json](examples/daemon-userns-remap.json)).
- Run as non-root **inside** too (defense-in-depth). Verify: [examples/namespace-demo.sh](examples/namespace-demo.sh).

## Compliance
| NIST 800-190 4.x | CIS Docker 5.9/5.15/5.16 | ISO A.8.22 |
|---|---|---|
| runtime isolation | no host net/pid/ipc | segregation |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Name 4 namespaces. What does user-ns remap achieve? Why is `--net=host` risky? **Interview —** *B:* What isolates a container? *I:* Explain user namespaces & rootless. *A:* Which ns sharing is safe vs dangerous, and why namespaces don't stop kernel escapes. **Scenario:** a debug container ran `--pid=host --privileged` → it could inspect/kill host procs; remove host ns, enable remap, add admission policy to block hostPID.
