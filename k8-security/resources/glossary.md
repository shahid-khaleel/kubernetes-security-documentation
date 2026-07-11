# 📚 Glossary

**DAC** — Discretionary Access Control; owner sets permissions (Linux mode bits/ACLs).
**MAC** — Mandatory Access Control; central policy overrides owner (SELinux/AppArmor).
**LSM** — Linux Security Module; kernel hook framework for SELinux/AppArmor.
**Namespace** — kernel isolation of a resource view (pid/net/mnt/uts/ipc/user/cgroup).
**cgroup** — control group; limits/accounts resource usage (cpu/mem/pids/io).
**Capability** — a slice of root's power (e.g. CAP_NET_BIND_SERVICE) grantable individually.
**seccomp** — secure computing; syscall filter (BPF) restricting which syscalls a process may call.
**SUID/SGID** — run a binary as its owner/group; classic privilege-elevation primitive.
**OCI** — Open Container Initiative; image + runtime specs (runc is the reference runtime).
**runc / containerd / shim** — low-level runtime / lifecycle manager / per-container supervisor.
**Rootless** — running the container engine/containers as an unprivileged user via user namespaces.
**RBAC** — Role-Based Access Control; K8s Roles/ClusterRoles + Bindings.
**Admission controller** — intercepts API requests to validate/mutate objects before persistence.
**PSA** — Pod Security Admission; enforces Pod Security Standards (privileged/baseline/restricted).
**SecurityContext** — pod/container security settings (runAsNonRoot, caps, readOnlyRootFilesystem…).
**NetworkPolicy** — K8s firewall rules for pod-to-pod traffic (needs a policy-enforcing CNI).
**mTLS** — mutual TLS; both client and server present certs (service mesh identity).
**Service Account (SA)** — non-human identity for pods to call the API; carries a token.
**etcd** — K8s key-value store holding all cluster state (incl. Secrets) — encrypt it.
**SBOM** — Software Bill of Materials; inventory of components in an artifact.
**SLSA** — Supply-chain Levels for Software Artifacts; build-integrity maturity model.
**Sigstore/Cosign** — keyless signing using short-lived OIDC certs (Fulcio) + transparency log (Rekor).
**eBPF** — in-kernel programmable observability/enforcement (Falco, Cilium, Tetragon).
**FIM** — File Integrity Monitoring (AIDE/Tripwire).
**IOC** — Indicator of Compromise.
**MITRE ATT&CK** — adversary tactics/techniques knowledge base (has a Containers matrix).
**STRIDE** — threat model taxonomy (Spoofing/Tampering/Repudiation/Info-disclosure/DoS/Elevation).
**RTO/RPO** — Recovery Time / Recovery Point Objective (DR targets).
**Container escape** — breaking out of container isolation to the host (the prime container threat).
