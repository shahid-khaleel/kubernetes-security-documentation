# Windows Containers in Kubernetes

**What it is.** Kubernetes supports **Windows worker nodes** running Windows containers
alongside Linux nodes (control plane stays Linux). Windows uses different isolation:
**process isolation** (shared kernel, like Linux containers) or **Hyper-V isolation** (each
container in a lightweight VM — a real kernel boundary).

**Why it matters (security).** The Linux security model **does not fully apply**:
- **No** Linux capabilities, seccomp, AppArmor/SELinux, or `runAsUser` (uid) — those pod fields
  are **silently ignored** on Windows.
- Isolation is via **Job Objects / server silos**; strong isolation needs **Hyper-V**.
- `hostProcess` containers = privileged host access on Windows (tightly restrict).

**What DOES apply / Windows equivalents**
| Need | Windows mechanism |
|---|---|
| Non-root | `securityContext.windowsOptions.runAsUserName: ContainerUser` |
| Strong isolation | **Hyper-V isolated** containers (RuntimeClass/annotation) |
| AD authentication | **gMSA** (Group Managed Service Accounts) — not embedded creds |
| Privileged (careful) | `hostProcess` — restrict via admission/RBAC |

**Best practices:** run as ContainerUser; use Hyper-V isolation for untrusted workloads; patch
Windows nodes; restrict hostProcess pods; use gMSA; label nodes by OS and require it
([Node Declared Features](../../03-scheduling-preemption-eviction/18-node-declared-features/)).
**Cross-links:** [Running Windows Containers — Guide](../02-guide-running-windows-containers/), [Security for Windows Nodes](../../01-security/07-security-for-windows-nodes/).
