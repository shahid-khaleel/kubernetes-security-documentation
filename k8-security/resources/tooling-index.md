# 🧰 Security Tooling Index

| Tool | Category | What it does | Module |
|------|----------|--------------|--------|
| **Trivy** | Image/IaC scan | CVEs, secrets, misconfig, SBOM | DKR09, K8s22 |
| **Grype / Syft** | Scan / SBOM | CVE scan / generate SBOM | DKR09/14 |
| **Docker Scout** | Image scan | CVEs + policy in Docker toolchain | DKR09 |
| **Snyk** | Scan | Dev-first vuln + license scanning | DKR09 |
| **Cosign / Sigstore** | Signing | Sign & verify images/attestations (keyless) | DKR14, K8s17 |
| **Notary v2 / Notation** | Signing | OCI artifact signing | DKR14 |
| **kube-bench** | Posture | CIS Kubernetes Benchmark checks | K8s22 |
| **kube-hunter** | Pen-test | Active cluster attack-surface probing | K8s22 |
| **Kubescape** | Posture | NSA/MITRE/CIS frameworks, RBAC viz | K8s22 |
| **Kyverno** | Admission | Policy-as-YAML validate/mutate/verifyImages | K8s05/17 |
| **OPA Gatekeeper** | Admission | Rego policy constraints | K8s05 |
| **Falco** | Runtime | eBPF/syscall threat detection | K8s19 |
| **Tetragon** | Runtime | eBPF observability + enforcement | K8s19 |
| **Cilium** | CNI/Network | eBPF networking + NetworkPolicy (L3-L7) | K8s15 |
| **Calico** | CNI/Network | NetworkPolicy enforcement | K8s15 |
| **Istio / Linkerd** | Mesh | mTLS + L7 authZ | K8s16 |
| **Vault** | Secrets | Dynamic secrets, PKI, transit encryption | K8s14 |
| **External Secrets Operator** | Secrets | Sync external stores → k8s Secrets | K8s14 |
| **Velero** | Backup/DR | Cluster + PV backup/restore | K8s24 |
| **Lynis** | Host audit | Linux hardening assessment | LNX14/16 |
| **OpenSCAP** | Compliance | CIS/STIG automated scan + remediation | LNX16 |
| **auditd** | Audit | Kernel-level audit trail | LNX12 |
| **AIDE / Tripwire** | FIM | File integrity monitoring | LNX14 |
| **ClamAV** | AV | Malware scanning | LNX14 |
| **rkhunter / chkrootkit** | Rootkit | Rootkit detection | LNX14 |
| **Fail2Ban** | IPS | Brute-force ban | LNX13 |
| **gVisor / Kata** | Sandbox | Stronger container isolation | DKR04 |
| **osquery** | Fleet | SQL over host/endpoint state | LNX/DKR |
