#!/usr/bin/env bash
# harden-linux-host.sh — apply a baseline of CIS-aligned Linux hardening.
# REVIEW each block; run in a lab first. Idempotent where possible.
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "run as root"; exit 1; }
back(){ cp -n "$1" "$1.bak.$(date +%s)" 2>/dev/null || true; }

echo "[1/6] sysctl kernel/network hardening"
cat > /etc/sysctl.d/99-hardening.conf <<'SYS'
kernel.randomize_va_space=2
kernel.kptr_restrict=2
kernel.dmesg_restrict=1
kernel.yama.ptrace_scope=1
kernel.unprivileged_bpf_disabled=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.tcp_syncookies=1
fs.protected_symlinks=1
fs.protected_hardlinks=1
fs.suid_dumpable=0
SYS
sysctl --system >/dev/null

echo "[2/6] secure default umask"
echo 'umask 027' > /etc/profile.d/00-umask.sh

echo "[3/6] lock down sensitive files"
chmod 600 /etc/shadow /etc/gshadow 2>/dev/null || true
chmod 644 /etc/passwd /etc/group
chmod 440 /etc/sudoers
chmod 700 /root

echo "[4/6] SSH hardening (backs up first; validates)"
if [[ -f /etc/ssh/sshd_config ]]; then
  back /etc/ssh/sshd_config
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
  sshd -t && echo "  sshd config valid (reload manually: systemctl reload sshd)"
fi

echo "[5/6] enable auditd + core audit rules"
systemctl enable --now auditd 2>/dev/null || true
cat > /etc/audit/rules.d/hardening.rules <<'AUD'
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k priv
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -k perm_mod
AUD
augenrules --load 2>/dev/null || true

echo "[6/6] done. Recommended next: mount /tmp,/dev/shm nosuid,noexec,nodev (see Linux module 10)."
echo "Verify posture with: lynis audit system"
