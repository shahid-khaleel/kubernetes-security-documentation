# 🐧 Track 1 — Linux Security

The foundation. Every container isolation feature (namespaces, cgroups, capabilities,
seccomp, SELinux/AppArmor) is a **Linux kernel** feature. Master this and Kubernetes
security stops being memorization.

## Modules
| # | Module | Level |
|---|--------|:-----:|
| 01 | [Permissions, ACLs, SUID/SGID, Sticky bit](01-permissions-acls-suid-sgid-sticky/) | 🟢 |
| 02 | [PAM & Authentication](02-pam-and-authentication/) | 🟡 |
| 03 | [SSH Hardening](03-ssh-hardening/) | 🟢 |
| 04 | [sudo & Privilege Escalation](04-sudo-and-privilege-escalation/) | 🟡 |
| 05 | [MFA](05-mfa/) | 🟡 |
| 06 | [SELinux](06-selinux/) | 🔴 |
| 07 | [AppArmor](07-apparmor/) | 🔴 |
| 08 | [Kernel Hardening (sysctl)](08-kernel-hardening-sysctl/) | 🔴 |
| 09 | [Secure Boot & LUKS](09-secure-boot-and-luks/) | 🔴 |
| 10 | [Filesystem & Mount Security](10-filesystem-and-mount-security/) | 🟡 |
| 11 | [Firewalls: iptables/nftables/firewalld](11-firewalls-iptables-nftables-firewalld/) | 🔴 |
| 12 | [auditd / journald / rsyslog](12-auditd-journald-rsyslog/) | 🔴 |
| 13 | [Fail2Ban & Intrusion Prevention](13-fail2ban-and-intrusion-prevention/) | 🟡 |
| 14 | [Lynis / ClamAV / chkrootkit / rkhunter](14-lynis-clamav-chkrootkit-rkhunter/) | 🟡 |
| 15 | [TLS, PKI, OpenSSL, Certificates](15-tls-pki-openssl-certificates/) | 🔴 |
| 16 | [CIS & STIG Compliance](16-cis-stig-compliance/) | 🔴 |
| 17 | [Incident Response & Forensics](17-linux-incident-response-and-forensics/) | ⚫ |

## The Linux security model in one diagram
```
                    ┌──────────────────────────────────────────┐
                    │              USER SPACE                    │
                    │  processes · files · sockets               │
                    └───────────────┬────────────────────────────┘
                                    │ syscalls
   ┌───────────────────────────────▼────────────────────────────────┐
   │                         KERNEL                                   │
   │  DAC (uid/gid perms) ─┐                                          │
   │  Capabilities  ───────┤  every syscall passes through           │
   │  seccomp-bpf   ───────┤  these gates before it runs             │
   │  LSM: SELinux/AppArmor┘  (MAC — mandatory access control)       │
   │  Namespaces (what you can SEE) · cgroups (what you can USE)      │
   └──────────────────────────────────────────────────────────────────┘
```
**DAC** (discretionary, module 01) says *who owns what*. **Capabilities** (split root
into 40+ privileges). **seccomp** filters *which syscalls* are allowed. **LSM/MAC**
(SELinux/AppArmor) enforces *policy the user can't override*. **Namespaces + cgroups**
provide *isolation* — the basis of containers. Learn them in that order.

> Start with [01 — Permissions](01-permissions-acls-suid-sgid-sticky/).
