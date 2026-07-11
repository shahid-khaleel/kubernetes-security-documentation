# Security for Windows Nodes

**What it is.** Hardening **Windows worker nodes** and Windows containers. Windows containers
use **different isolation primitives** than Linux — no Linux capabilities/seccomp/SELinux;
instead Job Objects, server silos, and (optionally) **Hyper-V isolation** (a real VM boundary).

**Why it matters.** Many security fields you rely on are **Linux-only and silently ignored on
Windows** (`runAsUser`, `capabilities`, `seccompProfile`, `readOnlyRootFilesystem` behavior
differs). Applying a "Restricted" mindset requires Windows-specific settings.

**Windows securityContext example**
```yaml
spec:
  securityContext:
    windowsOptions:
      runAsUserName: "ContainerUser"     # not root/ContainerAdministrator
  containers:
  - name: app
    image: mcr.microsoft.com/windows/nanoserver:ltsc2022
```

**Best practices**
- Run as **ContainerUser**, not ContainerAdministrator; use **Hyper-V isolation** for
  untrusted workloads. Patch Windows nodes on cadence.
- Restrict `hostProcess` containers (privileged on Windows) tightly.
- Use Group Managed Service Accounts (gMSA) for AD auth instead of embedding creds.
**Cross-links:** [Windows in Kubernetes](../../06-windows/), [Pod Security Standards](../02-pod-security-standards/).
