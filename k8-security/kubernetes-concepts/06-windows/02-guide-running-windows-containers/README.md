# Guide — Running Windows Containers (Securely)

**What it is.** Practical steps to schedule and secure Windows workloads in a mixed cluster.

**1) Target Windows nodes explicitly**
```yaml
spec:
  nodeSelector:
    kubernetes.io/os: windows
  tolerations:                       # if Windows nodes are tainted
    - { key: os, operator: Equal, value: windows, effect: NoSchedule }
  securityContext:
    windowsOptions:
      runAsUserName: "ContainerUser" # NOT ContainerAdministrator
  containers:
    - name: app
      image: mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-ltsc2022
```

**2) Match container OS build to the node** (Windows containers are build-version sensitive
unless Hyper-V isolated).

**3) Security must-dos**
- Run as **ContainerUser**; avoid **ContainerAdministrator** and unrestricted `hostProcess`.
- **Hyper-V isolation** for untrusted/multi-tenant Windows workloads.
- **gMSA** for domain auth (`GMSACredentialSpec`), never baked-in credentials.
- Patch Windows nodes on cadence; scan Windows images (Trivy/Defender); segment with
  NetworkPolicy (CNI must support Windows).
- Remember Linux-only pod security fields are ignored — don't rely on them for enforcement.

**4) Observability:** ship Windows Event Logs + container logs to the central pipeline; monitor
node patch status.
**Cross-links:** [Windows Containers](../01-windows-containers-in-kubernetes/), [Security for Windows Nodes](../../01-security/07-security-for-windows-nodes/), [Node Declared Features](../../03-scheduling-preemption-eviction/18-node-declared-features/).
