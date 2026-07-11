# 01 — Docker Architecture (Security View)

> **Track:** Docker Security · **Level:** 🟢 Beginner (foundation for the whole track)
> **Prerequisites:** [Linux permissions](../../linux-security/01-permissions-acls-suid-sgid-sticky/), basic shell
> **Est. time:** 3–4 hrs · **Refs:** CIS Docker 1.x/2.x, NIST 800-190

**Learning objectives — after this lesson you can:**
- [ ] Name every component in the Docker stack and its trust level.
- [ ] Explain why "the daemon runs as root" is the central Docker security fact.
- [ ] Trace a `docker run` from CLI to a running process and identify each attack surface.
- [ ] Distinguish container isolation from VM isolation and reason about escape risk.

---

## 1. What it is
Docker is a **container platform**: a client/daemon system that packages an application
plus its dependencies into an **image**, then runs it as an isolated **container** — a
set of host processes confined by Linux **namespaces** (what it can see) and **cgroups**
(what it can use). Modern Docker is not a monolith; it's a stack: `docker` CLI →
`dockerd` (daemon) → `containerd` (container lifecycle) → `containerd-shim` (per-container
supervisor) → `runc` (OCI runtime that actually creates the container).

## 2. Why it exists
Before containers, teams shipped apps as VMs (heavy, slow, minutes to boot) or installed
straight onto hosts ("works on my machine" dependency hell). Containers gave VM-like
isolation with process-like speed by reusing the **host kernel** instead of booting a
guest OS. Docker's contribution was the *developer experience* — a simple CLI, a
layered image format, and a registry to share images. The multi-component architecture
(splitting out `containerd`/`runc`) came later to standardize (OCI) and shrink the
root-privileged surface.

## 3. The problem it solves
- **Consistency:** the image is the same in dev, CI, and prod.
- **Density & speed:** many containers per host, sub-second start.
- **Isolation:** one app's crash/compromise is (ideally) contained.

The security tension it *introduces*: containers **share the host kernel**. That single
fact drives every attack and defense in this track. A VM has its own kernel behind a
hypervisor; a container does not.

## 4. How it works internally
A `docker run nginx` request flows like this:

1. **`docker` CLI** sends an HTTP request to **`dockerd`** over `/var/run/docker.sock`
   (a Unix socket). *This socket is root-equivalent* (see §6).
2. **`dockerd`** handles image pull, networking, volumes, then delegates container
   lifecycle to **`containerd`** via gRPC.
3. **`containerd`** creates a **`containerd-shim`** process per container. The shim is the
   container's parent and keeps it alive even if `dockerd`/`containerd` restart
   (`live-restore`).
4. The shim invokes **`runc`** (the OCI runtime). `runc`:
   - unshares **namespaces** (pid, net, mnt, uts, ipc, and optionally user, cgroup),
   - sets up **cgroups** (cpu/mem/pids limits),
   - drops **capabilities** to a default set (~14 of ~40),
   - applies the **seccomp** profile (blocks ~44 dangerous syscalls by default),
   - applies **AppArmor/SELinux** labels,
   - pivots into the container root filesystem and `execve()`s the entrypoint.
5. **`runc` exits** after `execve` — it's a "create-then-leave" runtime. The shim remains.

The container is now just a **Linux process** (`nginx`) whose kernel views are narrowed
by namespaces and whose resources are capped by cgroups.

## 5. Architecture
```
  USER SPACE                                              TRUST LEVEL
  ┌──────────┐   /var/run/docker.sock (ROOT-equivalent)   
  │ docker   │ ───────────────► ┌───────────┐  runs as ROOT ★ biggest surface
  │  CLI     │      REST/HTTP    │  dockerd  │   (build, network, volumes, images)
  └──────────┘                   └─────┬─────┘
                                   gRPC │
                                 ┌──────▼──────┐  runs as ROOT
                                 │ containerd  │   (image + container lifecycle)
                                 └──────┬──────┘
                            one per     │ exec
                            container ┌─▼───────────────┐   ROOT (parent of ctr)
                                      │ containerd-shim │   keeps container alive
                                      └─────┬───────────┘
                                        run │ (create, then exit)
                                       ┌────▼────┐
                                       │  runc   │  sets ns/cgroups/caps/seccomp/LSM
                                       └────┬────┘
   ═══════════════════════════════════════ │ ═════════════ TRUST BOUNDARY ═══════
                                    ┌───────▼────────┐
                                    │  CONTAINER      │  your app process
                                    │  (nginx pid 1)  │  confined by ns + cgroups
                                    └────────────────┘
                              ▲ SHARED HOST KERNEL (single point of failure) ▲
```

## 6. Security risks
- **The daemon runs as root.** Anyone who can talk to `dockerd` (the socket) can run
  `docker run -v /:/host --privileged … chroot /host` → **full host root**. Membership in
  the `docker` group **is** root; treat it as such.
- **`/var/run/docker.sock` exposure** — mounted into a container, exposed over TCP without
  TLS, or shared with CI = instant privilege escalation (full lesson in
  [module 06](../06-daemon-and-socket-security/)).
- **Shared kernel** — a kernel LPE (local privilege escalation) or a runtime bug
  (e.g. **CVE-2019-5736** runc host-binary overwrite) can escape the container.
- **Over-privileged containers** — `--privileged`, added dangerous capabilities
  (`SYS_ADMIN`), host namespaces (`--pid=host`, `--net=host`), host bind-mounts.
- **Untrusted images** — pulling `:latest` from a public registry runs someone else's code
  as (namespaced) root by default.

## 7. Common attacks (MITRE ATT&CK for Containers)
- **T1610 Deploy Container / T1611 Escape to Host:** abuse `docker.sock` or `--privileged`
  to spawn a container that mounts host `/` and `chroot`s in.
- **T1610 via exposed API:** `dockerd` on `tcp://0.0.0.0:2375` (no TLS) → remote root; a
  classic internet-scan finding, widely exploited for cryptomining.
- **Runtime escape:** exploit `runc`/kernel (CVE-2019-5736, CVE-2022-0492 cgroups) to
  overwrite host binaries or break out.
- **Image supply-chain:** typosquatted/backdoored base image executes on pull/run.

## 8. Real-world production use cases
- **Build/CI runners** package and test apps; the #1 place `docker.sock` gets dangerously
  shared — prefer rootless or Kaniko/BuildKit without the socket.
- **Microservices** on Docker/Kubernetes — the runtime under every pod is `containerd`+`runc`.
- **Edge/IoT** — small footprint containers; `containerd` alone (no full Docker) is common.
- **Data science** — GPU containers; watch `--privileged`/device mounts.

## 9. Best practices
1. **Never expose the Docker socket** to containers or over unencrypted TCP.
2. **Prefer rootless Docker** ([module 05](../05-rootless-docker/)) for dev and CI.
3. **Run containers as non-root**, read-only rootfs, drop capabilities, `no-new-privileges`
   ([module 11](../11-runtime-hardening-caps-seccomp-apparmor-selinux/)).
4. **Pin images by digest**, scan them ([module 09](../09-image-scanning-trivy-grype-scout-snyk/)),
   and verify signatures ([module 14](../14-supply-chain-sbom-cosign-notary/)).
5. **Keep `dockerd`/`containerd`/`runc` patched** — runtime CVEs are escape-grade.
6. **Treat `docker` group membership as root** in access reviews.

## 10. Hardening techniques
```bash
# Harden the daemon (see examples/ ../06). /etc/docker/daemon.json:
#   "userns-remap":"default","no-new-privileges":true,"icc":false,"live-restore":true

# If you must expose the API remotely, use mTLS — never plain 2375:
dockerd --tlsverify --tlscacert=ca.pem --tlscert=srv.pem --tlskey=srv-key.pem -H=0.0.0.0:2376

# Verify runtime versions are patched
docker version --format '{{.Server.Version}}'; runc --version; containerd --version

# Confirm no container has the socket mounted
docker ps -q | xargs -r docker inspect -f '{{.Name}} {{.Mounts}}' | grep docker.sock || echo "clean"

# Enable Docker Content Trust for pulls (verify signed images)
export DOCKER_CONTENT_TRUST=1
```
Run the stack tour: [`examples/inspect-architecture.sh`](examples/inspect-architecture.sh).

## 11. Compliance requirements
| Framework | Control | Requirement |
|-----------|---------|-------------|
| CIS Docker | 1.x, 2.x | Host + daemon config; audit `dockerd`, socket perms, TLS |
| NIST 800-190 | 4.x | Container runtime & host OS countermeasures |
| PCI DSS 4.0 | 2.2 | Secure config baselines for system components |
| ISO 27001 | A.8.9 | Configuration management |
| SOC 2 | CC6.6, CC6.8 | Boundary protection, unauthorized-software prevention |

## 12. Performance considerations
Containers add near-zero CPU overhead (native processes). Overhead sources: overlay
storage driver on write-heavy workloads, userland proxy for port publishing (disable
`userland-proxy`), and `userns-remap` (small, worth it). Sandboxed runtimes (gVisor/Kata,
[module 04](../04-containerd-runc/)) trade ~10–30% syscall/perf overhead for stronger
isolation — a deliberate multi-tenant choice.

## 13. Troubleshooting techniques
| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `permission denied` on socket | user not in `docker` group (which == root) | add carefully, or use rootless |
| Containers keep running after `dockerd` restart | `live-restore` + shim — expected | not a bug |
| `docker` CLI hangs | daemon down or socket perms | `systemctl status docker`; `ls -l docker.sock` |
| Escape via CI job | pipeline mounts `docker.sock` | switch to rootless/BuildKit/Kaniko |
| Old runc, escape CVE flagged | unpatched runtime | update `runc`/`containerd`/Docker |

## 14. Monitoring & auditing
- **auditd watch** on the daemon and socket: `-w /usr/bin/dockerd -k docker`,
  `-w /var/run/docker.sock -k docker`, `-w /etc/docker -p wa -k docker`.
- **`docker events`** stream for create/exec/mount ([module 13](../13-logging-and-monitoring/)).
- **Falco** rules for "container spawned with docker.sock mounted", "privileged container
  started" (K8s [module 19](../../kubernetes-security/19-runtime-security-falco-ebpf/)).
- Run **CIS Docker Benchmark** via `docker-bench-security`.

## 15. Logging
`dockerd`/`containerd` log to `journald` (`journalctl -u docker -u containerd`). Container
stdout/stderr via the configured **log driver** (json-file default — cap size!). Ship to a
central store; an attacker with host root can delete local logs.

## 16. Disaster recovery & backup
Back up: **images** (registry is source of truth — don't rely on local cache), **named
volumes** (`docker run --rm -v vol:/data -v $PWD:/backup alpine tar czf /backup/vol.tgz /data`),
and **daemon config** (`/etc/docker/daemon.json`). Container filesystems are ephemeral by
design — persist state in volumes/DBs. RTO is fast: redeploy from image + restore volume.

## 17. Common interview questions (signature)
- *Walk me through `docker run` from CLI to running process.* (The §4 chain.)
- *Why is being in the `docker` group equivalent to root?* (Socket → `-v /:/host` → host root.)

## 18. Common mistakes engineers make
- Adding users to the `docker` group without realizing it's root-equivalent.
- Exposing `dockerd` on `tcp://:2375` with no TLS "for the CI server."
- Mounting `docker.sock` into an app/CI container for "convenience."
- Assuming a container is as isolated as a VM.
- Running everything as root inside the container because "it's already isolated."

## 19. Advanced concepts
- **Rootless Docker** ([module 05](../05-rootless-docker/)) runs `dockerd` as a normal
  user via user namespaces — a container escape lands on an unprivileged uid.
- **Sandboxed runtimes:** gVisor (`runsc`) interposes a user-space kernel; Kata runs a
  micro-VM per container — real defense against kernel-exploit escapes.
- **The OCI specs** (image-spec, runtime-spec) — Docker is one implementation; `containerd`
  + `runc` are reusable by Kubernetes directly (Docker isn't needed to run K8s).
- **Shim v2 / API** and how `live-restore` decouples container lifetime from the daemon.

## 20. Production examples — banking / fintech / healthcare / cloud-native
- **Banking:** build farms run **rootless** or use **Kaniko** so no pipeline touches
  `docker.sock`; daemons are CIS-benchmarked; `runc`/`containerd` patch SLAs are 48h for
  escape-grade CVEs; images pulled only from a signed internal registry.
- **Fintech (PCI):** Docker API never on TCP; access to hosts running `dockerd` is a
  privileged-access-managed (PAM/bastion) action; `docker` group membership is a reviewed
  privileged role.
- **Healthcare:** ePHI workloads run on **gVisor/Kata** for kernel-exploit resistance;
  host + daemon hardening evidenced for HIPAA §164.308.
- **Cloud-native:** most clusters use **containerd directly** (Docker shim removed in
  K8s 1.24+); the security lessons here map 1:1 to the runtime under every pod.

---

## 📝 Summary
- Docker is a stack: CLI → `dockerd` → `containerd` → `shim` → `runc` → your process.
- **The daemon runs as root; the socket and `docker` group are root-equivalent.**
- Containers share the **host kernel** → escapes come from the socket, over-privilege,
  or kernel/runtime CVEs — not from magic.
- Defense = don't expose the socket, run rootless + non-root + least-privilege, patch the
  runtime, and use sandboxed runtimes for untrusted/multi-tenant workloads.

## 🧪 Hands-on Lab
See [`labs/lab.md`](labs/lab.md) and [`examples/inspect-architecture.sh`](examples/inspect-architecture.sh).
Map the process tree, then in a lab prove the `docker.sock` → host-root escape and its
prevention (detailed in [module 06 lab](../06-daemon-and-socket-security/labs/lab.md)).

## 🔧 Troubleshooting Exercise
Your CI jobs can suddenly read files from the *host* filesystem. You find the pipeline
mounts `/var/run/docker.sock`. Explain the exact escalation path and give two fixes that
don't break the build. (Answer: socket → `docker run -v /:/host` → host root; fix with
rootless Docker or a socket-free builder like BuildKit/Kaniko.)

## ❓ Quiz
1. Which component actually creates the container's namespaces/cgroups?
2. Why do containers keep running when you restart `dockerd`?
3. Why is `docker.sock` root-equivalent?
4. What's the fundamental isolation difference between a container and a VM?
5. Name two runtimes that provide stronger-than-runc isolation.
6. Which env var enables Docker Content Trust for pulls?
7. What does `runc` do right before it exits?
8. Is Docker required to run Kubernetes today? Why/why not?
9. Two dangerous flags that weaken container isolation?
10. Where do container stdout logs go by default, and what's the risk?

## 🎤 Interview Questions
**Beginner:** What is a container image vs a container? What runs as root in the Docker stack?
**Intermediate:** Trace `docker run` end to end and point out each security-relevant step
(socket, capabilities, seccomp, namespaces). How does `live-restore` work?
**Advanced:** You're securing a multi-tenant build platform. How do you eliminate
`docker.sock` exposure, defend against kernel-exploit escapes, and enforce that only
signed images run — with the trade-offs of each choice?

## 🏭 Production Scenario
An internet scan finds one of your staging hosts exposes `dockerd` on `2375/tcp` with no
TLS; cryptominer containers are already running. Walk the response: contain (firewall the
port, `docker ps`), eradicate (kill/remove miner containers + persistence), investigate
(daemon logs, `docker events`, image provenance), and prevent (never bind API to TCP
without mTLS; auditd watch on `/etc/docker`; harden daemon.json; add a scanning + admission
gate so unknown images can't run).

## 📌 Assignment / Mini-project
Write `docker-attack-surface.sh` that inventories, for a host: daemon exposure (socket
perms + any TCP bind), `docker` group members, containers with `--privileged`/host
namespaces/host mounts/`docker.sock` mounts, and runtime versions vs known escape CVEs.
Output a scored report mapped to CIS Docker Benchmark items.

---
### ✅ Quiz Answers
<details><summary>Reveal</summary>

1. `runc` (invoked by the shim).
2. The `containerd-shim` is the container's parent and survives daemon restarts
   (`live-restore`).
3. Talking to the socket = controlling a root daemon; you can launch a container that
   mounts host `/` and `chroot`s → host root.
4. A VM has its own guest kernel behind a hypervisor; a container **shares the host
   kernel** — a kernel exploit escapes it.
5. gVisor (`runsc`) and Kata Containers.
6. `DOCKER_CONTENT_TRUST=1`.
7. Sets up ns/cgroups/caps/seccomp/LSM, pivots root, `execve`s the entrypoint, then exits.
8. No — K8s uses CRI runtimes (containerd/CRI-O) directly; the dockershim was removed in
   1.24. The `containerd`+`runc` knowledge still applies.
9. `--privileged` and host namespaces (`--pid=host`/`--net=host`) — also `-v /:/host`.
10. To the json-file log driver on the host; an attacker with host root can delete them —
    ship logs off-host.
</details>
