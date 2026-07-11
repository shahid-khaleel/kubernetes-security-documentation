# 📖 Full Curriculum & Syllabus

Beginner → Expert. Three tracks, 58 modules. Each module is a self-contained lesson
in the 20-point format with labs, quizzes, and interview prep.

**Legend:** 🟢 Beginner · 🟡 Intermediate · 🔴 Advanced · ⚫ Expert/CKS-exam-grade

---

## ⏱️ Suggested Timeline

| Pace | Duration | Target |
|------|----------|--------|
| Intensive | 8 weeks | CKS exam / job switch |
| Standard | 16 weeks | Deep mastery while working |
| Relaxed | 6 months | Part-time, weekends |

Rule of thumb: **1 module ≈ 3–5 hours** (read + labs + quiz). 58 modules ≈ 200–290 hrs.

---

# TRACK 1 — 🐧 Linux Security (foundation)

> Containers are Linux processes with extra isolation. Master this layer first.

| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 01 | [Permissions, ACLs, SUID/SGID, Sticky bit](linux-security/01-permissions-acls-suid-sgid-sticky/) | 🟢 | DAC model, `chmod`/`chown`, `getfacl`/`setfacl`, umask, SUID abuse |
| 02 | [PAM & Authentication](linux-security/02-pam-and-authentication/) | 🟡 | `/etc/pam.d`, password policy, `pam_faillock`, `nsswitch` |
| 03 | [SSH Hardening](linux-security/03-ssh-hardening/) | 🟢 | key auth, `sshd_config`, ciphers, bastion, cert-based SSH |
| 04 | [sudo & Privilege Escalation](linux-security/04-sudo-and-privilege-escalation/) | 🟡 | `sudoers`, `NOPASSWD` risks, GTFOBins, least privilege |
| 05 | [MFA](linux-security/05-mfa/) | 🟡 | `pam_google_authenticator`, U2F/FIDO2, TOTP for SSH/sudo |
| 06 | [SELinux](linux-security/06-selinux/) | 🔴 | MAC, types/contexts, `audit2allow`, targeted vs strict |
| 07 | [AppArmor](linux-security/07-apparmor/) | 🔴 | profiles, `aa-genprof`, complain/enforce |
| 08 | [Kernel Hardening (sysctl)](linux-security/08-kernel-hardening-sysctl/) | 🔴 | `sysctl`, ASLR, `kptr_restrict`, module signing, lockdown |
| 09 | [Secure Boot & LUKS](linux-security/09-secure-boot-and-luks/) | 🔴 | UEFI Secure Boot, dm-crypt/LUKS, TPM, measured boot |
| 10 | [Filesystem & Mount Security](linux-security/10-filesystem-and-mount-security/) | 🟡 | `noexec`/`nosuid`/`nodev`, `/tmp`, immutable `chattr +i` |
| 11 | [Firewalls: iptables / nftables / firewalld](linux-security/11-firewalls-iptables-nftables-firewalld/) | 🔴 | netfilter, zones, egress control, connection tracking |
| 12 | [auditd / journald / rsyslog](linux-security/12-auditd-journald-rsyslog/) | 🔴 | audit rules, log forwarding, tamper-evident logging |
| 13 | [Fail2Ban & Intrusion Prevention](linux-security/13-fail2ban-and-intrusion-prevention/) | 🟡 | jails, filters, brute-force defense |
| 14 | [Lynis / ClamAV / chkrootkit / rkhunter](linux-security/14-lynis-clamav-chkrootkit-rkhunter/) | 🟡 | host audit, AV, rootkit detection, FIM (AIDE) |
| 15 | [TLS, PKI, OpenSSL, Certificates](linux-security/15-tls-pki-openssl-certificates/) | 🔴 | x509, CSR/CA, cipher suites, mTLS, rotation |
| 16 | [CIS & STIG Compliance](linux-security/16-cis-stig-compliance/) | 🔴 | CIS Benchmark, DISA STIG, OpenSCAP, remediation |
| 17 | [Incident Response & Forensics](linux-security/17-linux-incident-response-and-forensics/) | ⚫ | triage, memory/disk forensics, timeline, IOC hunting |

---

# TRACK 2 — 🐳 Docker Security

> Applying Linux primitives to build, run, and ship container images safely.

| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 01 | [Docker Architecture](docker-security/01-docker-architecture/) | 🟢 | client/daemon/containerd/runc/shim, OCI, attack surface |
| 02 | [Namespaces](docker-security/02-namespaces/) | 🔴 | pid/net/mnt/uts/ipc/user/cgroup ns, user-ns remap |
| 03 | [cgroups](docker-security/03-cgroups/) | 🔴 | v1/v2, resource limits, fork-bomb/DoS defense |
| 04 | [containerd & runc](docker-security/04-containerd-runc/) | 🔴 | OCI runtime, CVE-2019-5736, gVisor/Kata |
| 05 | [Rootless Docker](docker-security/05-rootless-docker/) | 🔴 | user-ns rootless, slirp4netns, limitations |
| 06 | [Daemon & Socket Security](docker-security/06-daemon-and-socket-security/) | 🔴 | `docker.sock` = root, TLS daemon, `--host` risks |
| 07 | [Dockerfile Best Practices](docker-security/07-dockerfile-best-practices/) | 🟢 | least privilege, pinning, `USER`, secrets, `.dockerignore` |
| 08 | [Multi-stage & Distroless](docker-security/08-multistage-and-distroless/) | 🟡 | minimal images, scratch/distroless/chainguard |
| 09 | [Image Scanning (Trivy/Grype/Scout/Snyk)](docker-security/09-image-scanning-trivy-grype-scout-snyk/) | 🟡 | CVE scanning, misconfig, CI gates |
| 10 | [Secrets Management](docker-security/10-secrets-management/) | 🔴 | build secrets, BuildKit `--secret`, no ENV secrets |
| 11 | [Runtime Hardening (caps/seccomp/AppArmor/SELinux)](docker-security/11-runtime-hardening-caps-seccomp-apparmor-selinux/) | 🔴 | `--cap-drop`, seccomp profiles, read-only rootfs |
| 12 | [Networking & Storage](docker-security/12-networking-and-storage/) | 🟡 | bridge/host/none, volume perms, tmpfs |
| 13 | [Logging & Monitoring](docker-security/13-logging-and-monitoring/) | 🟡 | log drivers, events, runtime telemetry |
| 14 | [Supply Chain: SBOM / Cosign / Notary](docker-security/14-supply-chain-sbom-cosign-notary/) | 🔴 | signing, provenance, SBOM, verification |
| 15 | [Docker Incident Response](docker-security/15-docker-incident-response/) | ⚫ | compromised container triage, `docker diff`, checkpoint |

---

# TRACK 3 — ☸️ Kubernetes Security

> Securing the orchestrator end-to-end. CKS-aligned. Depends on Tracks 1 & 2.

## Phase A — Cluster & Nodes
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 01 | [Control Plane Security](kubernetes-security/01-control-plane-security/) | 🔴 | apiserver/etcd/scheduler/controller-manager flags, etcd encryption/TLS |
| 02 | [Node Security](kubernetes-security/02-node-security/) | 🔴 | kubelet authN/authZ, `--anonymous-auth=false`, node isolation |

## Phase B — Identity & Access
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 03 | [Authentication](kubernetes-security/03-authentication/) | 🔴 | certs, OIDC, tokens, `kubeconfig`, service account tokens |
| 04 | [Authorization & RBAC](kubernetes-security/04-authorization-rbac/) | 🔴 | Roles/Bindings, least privilege, `can-i`, escalation paths |
| 05 | [Admission Controllers](kubernetes-security/05-admission-controllers/) | ⚫ | validating/mutating webhooks, OPA/Gatekeeper, Kyverno |
| 06 | [Pod Security Admission](kubernetes-security/06-pod-security-admission/) | 🔴 | PSA levels (privileged/baseline/restricted), PSP migration |

## Phase C — Workload Isolation (Linux LSMs in K8s)
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 07 | [Security Contexts](kubernetes-security/07-security-contexts/) | 🟡 | runAsNonRoot, readOnlyRootFilesystem, fsGroup, no-privesc |
| 08 | [Seccomp](kubernetes-security/08-seccomp/) | 🔴 | `RuntimeDefault`, custom profiles, Security Profiles Operator |
| 09 | [AppArmor & SELinux in K8s](kubernetes-security/09-apparmor-selinux-in-k8s/) | 🔴 | annotations/fields, per-container profiles |
| 10 | [Linux Capabilities](kubernetes-security/10-linux-capabilities/) | 🔴 | drop ALL, `NET_BIND_SERVICE`, dangerous caps |

## Phase D — Secrets & Data
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 11 | [Service Accounts](kubernetes-security/11-service-accounts/) | 🟡 | token projection, `automountServiceAccountToken`, bound tokens |
| 12 | [Secrets Management](kubernetes-security/12-secrets-management/) | 🔴 | base64≠encryption, RBAC on secrets, CSI secrets store |
| 13 | [Encryption at Rest](kubernetes-security/13-encryption-at-rest/) | 🔴 | `EncryptionConfiguration`, KMS provider, key rotation |
| 14 | [External Secrets & Vault](kubernetes-security/14-external-secrets-and-vault/) | 🔴 | ESO, Vault agent injector, dynamic secrets |

## Phase E — Network Security
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 15 | [Network Policies](kubernetes-security/15-network-policies/) | 🔴 | default-deny, ingress/egress, CNI (Calico/Cilium) |
| 16 | [Istio & mTLS](kubernetes-security/16-istio-and-mtls/) | ⚫ | service mesh, STRICT mTLS, AuthorizationPolicy |

## Phase F — Supply Chain & Images
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 17 | [Image Security & Signing (Cosign/Sigstore)](kubernetes-security/17-image-security-and-signing-cosign-sigstore/) | 🔴 | signing, keyless, admission verification |
| 18 | [SBOM, SLSA & Supply Chain](kubernetes-security/18-sbom-slsa-supply-chain/) | ⚫ | provenance, SLSA levels, in-toto, tamper resistance |

## Phase G — Runtime, Detection & Ops
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 19 | [Runtime Security (Falco / eBPF)](kubernetes-security/19-runtime-security-falco-ebpf/) | ⚫ | syscall detection, Falco rules, Tetragon |
| 20 | [Audit Logging](kubernetes-security/20-audit-logging/) | 🔴 | audit policy, backends, SIEM integration |
| 21 | [Cluster Hardening (CIS / NSA)](kubernetes-security/21-cluster-hardening-cis-nsa/) | 🔴 | CIS K8s benchmark, NSA/CISA guide |
| 22 | [kube-bench / kube-hunter / Kubescape](kubernetes-security/22-kube-bench-hunter-kubescape/) | 🟡 | automated posture scanning |

## Phase H — Tenancy, Continuity & Governance
| # | Module | Level | Core skills |
|---|--------|:-----:|-------------|
| 23 | [Multi-Tenancy](kubernetes-security/23-multi-tenancy/) | ⚫ | namespaces vs vClusters, quotas, isolation models |
| 24 | [Backup & Disaster Recovery](kubernetes-security/24-backup-and-disaster-recovery/) | 🔴 | Velero, etcd snapshots, RTO/RPO |
| 25 | [Compliance](kubernetes-security/25-compliance/) | 🔴 | PCI/HIPAA/SOC2/ISO mapping, evidence automation |
| 26 | [Incident Response & Threat Modeling](kubernetes-security/26-incident-response-and-threat-modeling/) | ⚫ | STRIDE/MITRE ATT&CK for Containers, IR playbooks |

---

# TRACK 4 — 📘 Kubernetes Concepts & Hardening (official-docs aligned)

> Mirrors the Kubernetes documentation concept tree — **through a security lens** — with
> runnable examples. Complements Track 3; cross-linked to its deep modules.
> Full index: [`kubernetes-concepts/`](kubernetes-concepts/).

| Section | Topics | Highlights |
|---------|:-----:|-----------|
| [01 · Security](kubernetes-concepts/01-security/) | 18 | 4 C's, Pod Security Standards/Admission, Service Accounts, PSP (legacy), Linux/Windows node security, controlling API access, RBAC & Secrets good practices, multi-tenancy, hardening guides (authN, DRA, scheduler), **API-server bypass risks**, Linux kernel constraints, security & app-security checklists |
| [02 · Policies](kubernetes-concepts/02-policies/) | 3 | Limit Ranges, Resource Quotas, PID limits & reservations |
| [03 · Scheduling, Preemption & Eviction](kubernetes-concepts/03-scheduling-preemption-eviction/) | 18 | Scheduler, topology-aware scheduling, node assignment, pod overhead, scheduling readiness, topology spread, taints/tolerations, scheduling framework, DRA, gang/PodGroup scheduling, perf tuning, bin packing, workload-aware & priority preemption, node-pressure & API-initiated eviction, node declared features |
| [04 · Cluster Administration](kubernetes-concepts/04-cluster-administration/) | 5 | Node shutdowns, swap memory, node autoscaling, certificates/PKI, cluster networking |
| [05 · Observability](kubernetes-concepts/05-observability/) | 12 | Admission-webhook & DRA-admin good practices, logging architecture, compatibility version, metrics (system + object states), system logs, traces, proxies, **API Priority & Fairness**, addons, coordinated leader election |
| [06 · Windows in Kubernetes](kubernetes-concepts/06-windows/) | 2 | Windows containers + secure-run guide (isolation differences, gMSA, Hyper-V) |
| [07 · Extending Kubernetes](kubernetes-concepts/07-extending-kubernetes/) | 3 | CRI/CSI/CNI/device extensions, CRDs & API aggregation, the **Operator pattern** |

---

## 🏆 Capstone Projects

### CAP-1 — Zero-Trust Bank Cluster ⚫
Build a hardened multi-tenant cluster: CIS-benchmarked control plane, etcd encryption
with KMS, RBAC least-privilege, default-deny NetworkPolicies, STRICT mTLS, Kyverno
admission policy requiring signed images + restricted PSA, Falco runtime detection,
audit logging to a SIEM, and Velero DR. Deliver an architecture diagram + kube-bench
score ≥ 95% + threat model.

### CAP-2 — Breach & Contain ⚫
Deploy a vulnerable app (exposed `docker.sock`, over-privileged pod). Perform: initial
access → container escape → node compromise → lateral movement → data exfil. Then
switch to blue team: detect via Falco/audit logs, contain (cordon/NetworkPolicy),
eradicate, and write a forensic RCA + MITRE ATT&CK mapping.

### CAP-3 — Compliance-in-a-Box 🔴
Take one platform and produce automated compliance evidence for **CIS + PCI-DSS + SOC 2**:
kube-bench, Lynis, OpenSCAP/STIG, Trivy image reports, and a control-to-evidence matrix
rendered as a report. Wire it into CI so every merge regenerates the evidence.

---

## 🧭 Compliance Coverage Matrix

Full mapping lives in [`resources/compliance-matrix.md`](resources/compliance-matrix.md).
Frameworks touched throughout: **CIS Benchmarks, PCI DSS 4.0, ISO/IEC 27001, SOC 2,
GDPR, HIPAA, NIST 800-53 / 800-190 (container security), DISA STIG, SLSA.**

---

## 📎 Quick Links

- [Lesson template](_templates/LESSON-TEMPLATE.md) · [Cheatsheets](resources/) ·
  [Reusable scripts](scripts/) · [Lab bootstrap](labs/README.md) ·
  [Tooling index](resources/tooling-index.md) · [Glossary](resources/glossary.md)
