# Linux Kernel Security Constraints for Pods & Containers

**What it is.** The **kernel-level primitives** Kubernetes uses to confine pods — the Linux
mechanisms from the [Linux](../../../linux-security/) and [Docker](../../../docker-security/)
tracks, expressed through pod fields.

**Why it matters.** These are the *actual* enforcement behind Pod Security Standards; knowing
them lets you reason about what a pod can really do (and how an escape happens).

**The primitives & their pod fields**
| Kernel feature | What it constrains | Pod/container field | Deep dive |
|---|---|---|---|
| **Namespaces** | resource *view* (pid/net/mnt/…) | `hostPID/hostNetwork/…: false` | [docker/02](../../../docker-security/02-namespaces/) |
| **cgroups** | resource *usage* (cpu/mem/pids) | `resources.limits`, LimitRange | [docker/03](../../../docker-security/03-cgroups/) |
| **Capabilities** | root's split privileges | `securityContext.capabilities` | [sec/10](../../../kubernetes-security/10-linux-capabilities/) |
| **seccomp** | allowed syscalls | `seccompProfile` | [sec/08](../../../kubernetes-security/08-seccomp/) |
| **AppArmor/SELinux** | MAC file/net confinement | `appArmorProfile`/`seLinuxOptions` | [sec/09](../../../kubernetes-security/09-apparmor-selinux-in-k8s/) |
| **no_new_privs** | block setuid escalation | `allowPrivilegeEscalation: false` | [sec/07](../../../kubernetes-security/07-security-contexts/) |
| **sysctls** | kernel tunables (some namespaced) | `securityContext.sysctls` (safe set) | [Linux/08](../../../linux-security/08-kernel-hardening-sysctl/) |

**Key security fact:** all containers share the **host kernel** — a kernel LPE bypasses every
constraint above. Hence: patch kernels, use seccomp/LSM to shrink attack surface, and use
sandboxed runtimes (gVisor/Kata) for untrusted workloads.
