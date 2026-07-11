# 🔧 Reusable Scripts
| Script | Purpose | Used by |
|--------|---------|---------|
| `permission-audit.sh` | Linux SUID/world-writable/DAC audit + drift baseline | Linux 01 |
| `harden-linux-host.sh` | Apply baseline CIS-aligned host hardening | Linux 03,08,10,12,16 |
| `install-security-tools.sh` | Install trivy/grype/syft/cosign/kubescape/lynis… | labs/ |
| `k8s-quick-audit.sh` | Fast RBAC/workload/network posture via kubectl+jq | K8s 04,06,07,11,15 |
> Read every script before running. Host-hardening scripts change system config — lab first.
