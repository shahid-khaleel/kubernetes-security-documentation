# 🐳 Track 2 — Docker Security

Applying Linux kernel primitives to build, run, and ship containers safely. A container
is **not a VM** — it's a set of Linux processes sharing the host kernel, isolated by
namespaces and cgroups. That shared kernel is the central security fact.

## Modules
| # | Module | Level |
|---|--------|:-----:|
| 01 | [Docker Architecture](01-docker-architecture/) | 🟢 |
| 02 | [Namespaces](02-namespaces/) | 🔴 |
| 03 | [cgroups](03-cgroups/) | 🔴 |
| 04 | [containerd & runc](04-containerd-runc/) | 🔴 |
| 05 | [Rootless Docker](05-rootless-docker/) | 🔴 |
| 06 | [Daemon & Socket Security](06-daemon-and-socket-security/) | 🔴 |
| 07 | [Dockerfile Best Practices](07-dockerfile-best-practices/) | 🟢 |
| 08 | [Multi-stage & Distroless](08-multistage-and-distroless/) | 🟡 |
| 09 | [Image Scanning (Trivy/Grype/Scout/Snyk)](09-image-scanning-trivy-grype-scout-snyk/) | 🟡 |
| 10 | [Secrets Management](10-secrets-management/) | 🔴 |
| 11 | [Runtime Hardening (caps/seccomp/AppArmor/SELinux)](11-runtime-hardening-caps-seccomp-apparmor-selinux/) | 🔴 |
| 12 | [Networking & Storage](12-networking-and-storage/) | 🟡 |
| 13 | [Logging & Monitoring](13-logging-and-monitoring/) | 🟡 |
| 14 | [Supply Chain: SBOM / Cosign / Notary](14-supply-chain-sbom-cosign-notary/) | 🔴 |
| 15 | [Incident Response](15-docker-incident-response/) | ⚫ |

## The one mental model that matters
```
        VM                              CONTAINER
  ┌───────────────┐              ┌───────────────┐ ┌──────────┐
  │  App          │              │  App (procs)  │ │  App     │
  │  Guest OS     │              └──────┬────────┘ └────┬─────┘
  │  Guest Kernel │                     │ namespaces + cgroups
  ├───────────────┤              ┌──────▼───────────────▼───────┐
  │  Hypervisor   │              │      SHARED HOST KERNEL       │ ← the trust boundary
  ├───────────────┤              ├───────────────────────────────┤
  │  Host Kernel  │              │           Host OS             │
  └───────────────┘              └───────────────────────────────┘
  Strong isolation               Weaker isolation, shared kernel =
  (separate kernel)              kernel exploit → escape to ALL containers
```
**Consequence:** a kernel vulnerability or a misconfigured privilege (`--privileged`,
mounted `docker.sock`, dropped-then-not caps) can break the container boundary. Every
module in this track exists to shrink that risk.

> Start with [01 — Docker Architecture](01-docker-architecture/).
