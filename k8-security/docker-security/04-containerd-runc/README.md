# 04 — containerd & runc (OCI Runtimes)

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** NIST 800-190, CIS Docker

**Objectives:** understand the OCI runtime layer; know escape CVEs; choose sandboxed runtimes (gVisor/Kata).

## Concept
**containerd** manages container lifecycle (pull, snapshot, run) and calls a low-level
**OCI runtime** — **runc** (reference) — which actually sets up namespaces/cgroups/caps/
seccomp and `execve`s the entrypoint, then exits. This layer is **root-privileged** and sits
directly on the host kernel, so its bugs are **escape-grade**. Alternative runtimes trade
performance for isolation: **gVisor (runsc)** = user-space kernel intercepting syscalls;
**Kata** = a lightweight VM per container (real hardware isolation).

## Risks & attacks
- **CVE-2019-5736**: a malicious container overwrote the host `runc` binary → host root.
  **CVE-2024-21626** (runc leaked fd / `WORKDIR`) → escape. Patch cadence is critical.
- Shared kernel means any kernel LPE escapes runc-based containers.

## Best practices & hardening
- Keep `runc`/`containerd` **patched** (verify versions). Read-only rootfs + userns reduce
  escape impact. For untrusted/multi-tenant workloads, use **gVisor or Kata**.
- Notes: [examples/gvisor-runsc.md](examples/gvisor-runsc.md).

## Compliance
| NIST 800-190 | CIS Docker | ISO A.8.8 |
|---|---|---|
| runtime countermeasures | patch runtime | vuln mgmt |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does runc do then? gVisor vs Kata? Why is CVE-2019-5736 severe? **Interview —** *B:* What is containerd vs runc? *I:* When use gVisor/Kata? *A:* Defend a multi-tenant platform against runtime-escape CVEs. **Scenario:** escape CVE announced → check versions, emergency-patch, add read-only+userns, evaluate sandboxed runtime for sensitive tenants.
