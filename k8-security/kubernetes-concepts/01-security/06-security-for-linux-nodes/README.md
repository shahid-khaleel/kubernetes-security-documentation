# Security for Linux Nodes

**What it is.** Hardening the **Linux hosts** that run kubelet + container runtime + pods.
Node security underlies pod security — a compromised node exposes every secret and workload
scheduled on it.

**Why it matters.** Container isolation ends at the shared kernel; the node OS is the real
boundary. This is where the entire [Linux Security track](../../../linux-security/) applies.

**Checklist (maps to Linux track modules)**
- Minimal OS, patched kernel; CIS-benchmarked ([Linux 16](../../../linux-security/16-cis-stig-compliance/)).
- Kubelet hardened: `anonymous-auth=false`, authZ `Webhook`, `readOnlyPort=0` ([security/02](../../../kubernetes-security/02-node-security/)).
- LSM enforcing: **SELinux/AppArmor** ([Linux 06](../../../linux-security/06-selinux/)/[07](../../../linux-security/07-apparmor/)); seccomp default.
- Kernel sysctls ([Linux 08](../../../linux-security/08-kernel-hardening-sysctl/)); mounts `nosuid,noexec` ([Linux 10](../../../linux-security/10-filesystem-and-mount-security/)).
- auditd + log forwarding ([Linux 12](../../../linux-security/12-auditd-journald-rsyslog/)); host firewall ([Linux 11](../../../linux-security/11-firewalls-iptables-nftables-firewalld/)).
- No workloads on control-plane nodes; node isolation for sensitive tenants.

**Best practices:** immutable/golden node images; automated drift detection (kube-bench +
Lynis); protect the cloud **metadata endpoint** from pods.
**Cross-links:** [security/02 — Node Security](../../../kubernetes-security/02-node-security/), whole [Linux track](../../../linux-security/).
