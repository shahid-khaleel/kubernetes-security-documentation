# 03 — cgroups (Container Isolation, Part 2)

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** NIST 800-190, CIS Docker 5.x

**Objectives:** limit cpu/mem/pids/io; defend against resource-exhaustion DoS; understand cgroup v1 vs v2 and escape CVEs.

## Concept
**cgroups (control groups)** limit and account a container's **resource usage** — CPU,
memory, PIDs, block I/O. Where namespaces control *what you see*, cgroups control *what you
can consume*. **cgroup v2** is the unified modern hierarchy (better delegation/safety) vs v1.
Setting limits prevents a single container from starving the host or its neighbors.

## Risks & attacks
- **No limits → DoS:** fork bomb (PID exhaustion), memory hog (OOM the host), CPU/IO starvation.
- **CVE-2022-0492** (cgroup v1 `release_agent`) allowed container escape → patch + userns + no `SYS_ADMIN`.
- Missing `pids` limit is the most-forgotten and enables fork bombs.

## Best practices & hardening
- Always set `--memory`, `--cpus`, `--pids-limit` (and K8s requests/limits). Prefer cgroup v2.
- Test: [examples/forkbomb-defense.sh](examples/forkbomb-defense.sh), [examples/resource-limits-compose.yaml](examples/resource-limits-compose.yaml).
- Patch the kernel/runtime for cgroup escape CVEs; don't grant `SYS_ADMIN`.

## Compliance
| NIST 800-190 | CIS Docker 5.10/5.11/5.28 | ISO A.8.6 |
|---|---|---|
| resource limits | memory/cpu/pids limits | capacity mgmt |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** namespaces vs cgroups? Which limit stops a fork bomb? v1 vs v2? **Interview —** *B:* What do cgroups do? *I:* How to prevent one container starving a host? *A:* cgroup escape CVEs and mitigations. **Scenario:** one container OOM-killed the node → set memory/pids/cpu limits, enable v2, add K8s LimitRange, verify a hog is contained.
