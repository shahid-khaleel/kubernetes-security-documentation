# 01 — Linux Permissions, ACLs, SUID/SGID & Sticky Bit

> **Track:** Linux Security · **Level:** 🟢 Beginner (with 🔴 advanced sections)
> **Prerequisites:** basic shell · **Est. time:** 4–5 hrs
> **Refs:** CIS Linux 1.1/6.1, NIST 800-53 AC-3/AC-6, PCI DSS 7.x

**Learning objectives — after this lesson you can:**
- [ ] Read and reason about any `ls -l` output including special bits.
- [ ] Use octal & symbolic `chmod`, `chown`, `umask`, POSIX ACLs correctly.
- [ ] Explain how the kernel evaluates a permission check on a syscall.
- [ ] Find and exploit a SUID misconfiguration in a lab, then remediate it.
- [ ] Audit a host for dangerous SUID/SGID/world-writable files.

---

## 1. What it is
Linux uses **Discretionary Access Control (DAC)**: every file/directory has an **owner
(user)**, a **group**, and a set of **permission bits** that decide what the owner, the
group, and everyone else ("others") may do. The classic bits are **read (r=4), write
(w=2), execute (x=1)** for each of the three classes. On top of that sit three **special
bits** — **SUID**, **SGID**, and the **sticky bit** — and a finer-grained extension,
**POSIX ACLs**, when three classes aren't enough.

"Discretionary" means the **owner decides** (can `chmod` their own files). This is the
opposite of Mandatory Access Control (SELinux/AppArmor, modules 06–07) where a
central policy overrides the owner.

## 2. Why it exists
Unix is multi-user. From day one it needed a cheap, in-inode way to answer "can this
process touch this file?" without consulting a database on every access. Storing 9 bits
+ owner/group in the inode makes the check a couple of integer comparisons in the
kernel — fast enough to run on **every** `open`, `exec`, `stat`. SUID was added so an
unprivileged user could run a program that legitimately needs elevated rights
(e.g. `passwd` must write `/etc/shadow`). ACLs were added later (POSIX.1e draft) because
"owner/group/other" can't express "these 3 specific users get write, that team gets read."

## 3. The problem it solves
- **Isolation between users** on a shared host (your files aren't readable by everyone).
- **Controlled privilege elevation** (SUID) — run a tightly-scoped privileged task
  without giving the user a root shell.
- **Shared collaboration directories** (SGID + sticky) — a team drop-folder where
  everyone can create files but nobody can delete others' files (`/tmp` is the classic).

Without it: any user reads any file, any process writes anything → no multi-tenancy,
no secrets, no integrity.

## 4. How it works internally
Each file has an **inode** storing `st_mode` (16 bits): 4 bits file type, **3 special
bits (setuid/setgid/sticky)**, and **9 permission bits**. When a process calls a syscall
that touches the file, the kernel runs a permission check (`inode_permission()` →
`generic_permission()`):

```
For a process with fsuid/fsgid + supplementary groups, kernel picks the FIRST
matching class and uses ONLY that class's bits (it does not fall through):

  if  process.fsuid == file.owner_uid   → use OWNER bits   (u)
  elif process.fsgid == file.group_gid
       or file.group in process.groups  → use GROUP bits   (g)
  else                                  → use OTHER bits    (o)

  Then CAP_DAC_OVERRIDE (root/capability) can bypass the check entirely.
```

Key, non-obvious consequence: **if you are the owner and the owner bits deny you, you
are denied even if group/other would allow** — the kernel stops at the first matching
class. Owning a file with mode `000` means *you* can't read it (but you can `chmod` it
back, because you own it).

**SUID/SGID mechanics:** normally a process runs with the **real UID** of the caller.
When you `execve()` a file with the SUID bit, the kernel sets the process's **effective
UID = file owner's UID**. So `/usr/bin/passwd` (owned by root, SUID) runs as root even
though you launched it. SGID does the same for the group. This is *the* privilege-
elevation primitive on Linux — and therefore a prime attack target.

**Sticky bit on a directory:** normally write on a directory lets you delete *any* file
in it (deletion is a directory operation, not a file operation!). The sticky bit
restricts deletion/rename to the **file's owner, the directory's owner, or root** — which
is why `/tmp` (mode `1777`) is world-writable but you can't delete other users' temp files.

## 5. Architecture
```
                 ls -l  output decoded
   -    rwx    r-x    r--    1  alice  devs  4096  file
   │    │      │      │         │      │
   │    │      │      └ OTHER   │      └ group = devs
   │    │      └ GROUP         └ owner = alice
   │    └ OWNER (u)
   └ type: - file, d dir, l symlink, c/b device, s socket, p pipe

   Special bits shown in the execute position:
     -rwsr-xr-x   s in OWNER exec  → SUID  set   (S if no underlying x)
     -rwxr-sr-x   s in GROUP exec  → SGID  set
     drwxrwxrwt   t in OTHER exec  → sticky set  (T if no underlying x)

   Octal mode = [special][u][g][o]
     4000 SUID   2000 SGID   1000 sticky
     0755 = rwxr-xr-x     4755 = rwsr-xr-x (SUID + 755)     1777 = /tmp

              PERMISSION CHECK PATH (per syscall)
   open()/exec()/stat() ─▶ kernel ─▶ DAC (this module) ─▶ Capabilities
                                   ─▶ ACLs (if present)  ─▶ LSM/MAC (SELinux/AppArmor)
   (Deny at ANY gate = deny. This module is the FIRST, cheapest gate.)
```

## 6. Security risks
- **SUID-root binaries** are the #1 local privilege-escalation vector. A bug (or a shell
  escape) in *any* SUID-root program can give a full root shell.
- **World-writable files** (`o+w`) — anyone can modify them. World-writable scripts run
  by root = instant privesc. World-writable `/etc/passwd` = game over.
- **Files owned by root but writable by a service user** → the service (if compromised)
  edits root-owned config.
- **Missing owner (unowned files)** after a user is deleted — new user reusing the UID
  inherits the files.
- **Over-broad ACLs** silently granting access invisible to `ls -l` (only a trailing `+`
  hints at them).
- **`umask` too permissive** (e.g. `000`) → newly created secrets are world-readable.

## 7. Common attacks (MITRE ATT&CK)
- **T1548.001 — Setuid/Setgid abuse:** find a SUID binary that can spawn a shell, read
  arbitrary files, or write files. See **GTFOBins** — e.g. SUID `find`, `vim`, `nmap`,
  `bash`, `cp`, `env`, `python`. `find . -exec /bin/sh -p \; -quit` from a SUID `find`
  gives root.
- **T1222 — File permission modification:** attacker `chmod +s /bin/bash` to plant a
  persistent SUID backdoor, or makes a cron-run script world-writable.
- **Writable `PATH`/script hijack:** a root cron job runs a script in a world-writable
  dir; attacker replaces it.
- **`/etc/shadow` or `/etc/sudoers` weak perms:** read hashes offline / grant self sudo.
- **Symlink/hardlink races** on sticky-less shared dirs (mitigated by
  `fs.protected_symlinks`, module 08).

## 8. Real-world production use cases
- **Legit SUID:** `passwd`, `sudo`, `su`, `ping` (historically), `mount`, `pkexec`.
  Production hardening replaces many of these with capabilities (e.g. `ping` uses
  `cap_net_raw` file capability instead of SUID on modern distros).
- **SGID collaboration dirs:** shared `/srv/team-data` with SGID so files inherit the
  team group — common in build servers, shared data-science volumes.
- **ACLs:** web servers where `www-data` needs read on app files owned by a deploy user
  without making them world-readable; NFS exports with per-user grants.
- **Sticky:** `/tmp`, `/var/tmp`, `/dev/shm` on every server.

## 9. Best practices
1. **Least privilege by default.** Files `640`/`600`, dirs `750`/`700`, secrets `600`
   owned by the app user.
2. **Set a restrictive `umask`** (`027` for servers, `077` for high-security) in
   `/etc/login.defs` and `/etc/profile.d/`.
3. **Minimize SUID/SGID.** Every SUID-root binary is attack surface — remove or replace
   with file **capabilities** where possible.
4. **No world-writable files;** world-writable dirs must have the sticky bit.
5. **Prefer ACLs over loosening owner/group/other** when you need per-user grants.
6. **Own config as root, run service as an unprivileged user**; service user gets read
   (not write) on its config.
7. **Audit continuously** (see §14) — baseline SUID set and alert on new ones.

## 10. Hardening techniques
```bash
# Find and review all SUID/SGID binaries (baseline them!)
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -printf '%m %u %g %p\n' 2>/dev/null

# Remove SUID from a binary you don't need it on
sudo chmod u-s /usr/bin/<binary>

# Replace SUID ping with a capability (modern approach)
sudo setcap cap_net_raw+ep /usr/bin/ping   # then chmod u-s /usr/bin/ping

# Find world-writable files (should be ~none) and world-writable dirs w/o sticky
find / -xdev -type f -perm -0002 2>/dev/null
find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null   # <-- fix these

# Fix a world-writable dir to be sticky
sudo chmod +t /path/to/dir

# Find files with no valid owner/group (orphaned)
find / -xdev \( -nouser -o -nogroup \) 2>/dev/null

# Lock down sensitive files
sudo chmod 600 /etc/shadow /etc/gshadow
sudo chmod 644 /etc/passwd /etc/group
sudo chmod 440 /etc/sudoers
sudo chmod 700 /root

# Set a secure default umask (server)
echo 'umask 027' | sudo tee /etc/profile.d/00-umask.sh

# Make a file immutable (belt-and-suspenders for critical config)
sudo chattr +i /etc/resolv.conf      # remove with -i
```
See runnable auditor: [`../../scripts/permission-audit.sh`](../../scripts/permission-audit.sh)
and lab files in [`./examples/`](./examples/) and [`./labs/`](./labs/).

## 11. Compliance requirements
| Framework | Control | Requirement |
|-----------|---------|-------------|
| CIS Linux | 1.1.x, 6.1.x | `/etc/passwd` 644, `/etc/shadow` 000/600, no world-writable files, audit SUID/SGID |
| PCI DSS 4.0 | 7.2, 7.3 | Restrict access by least privilege / need-to-know |
| ISO 27001 | A.8.3 / A.5.15 | Access control to information & assets |
| SOC 2 | CC6.1, CC6.3 | Logical access least privilege |
| NIST 800-53 | AC-3, AC-6, CM-5 | Access enforcement, least privilege, change restrictions |
| HIPAA | §164.312(a)(1) | Access control to ePHI |
| GDPR | Art. 32 | Appropriate technical measures (access limitation) |

## 12. Performance considerations
DAC checks are effectively free (in-inode integer compares). **ACLs** add a small cost:
they're stored as extended attributes (`system.posix_acl_access`) and require an extra
lookup; heavy ACL use on hot paths (millions of files, NFS) has measurable overhead —
keep ACLs shallow. `chattr +i` and `find /` scans are I/O heavy — run audits off-peak
or on snapshots.

## 13. Troubleshooting techniques
| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| "Permission denied" but perms look right | It's an **ACL** (note `+` in `ls -l`) or SELinux/AppArmor | `getfacl file`; check `ausearch -m avc` |
| Owner can't read own file | Owner bits are `000`/no-r; kernel stops at owner class | `chmod u+r file` |
| Can't delete a file in a writable dir | Sticky bit + you're not the owner | owner or root deletes it |
| New files world-readable | `umask` too loose | fix `umask`/`login.defs` |
| SUID bit "won't stick" | Filesystem mounted `nosuid` | check `mount`/`/etc/fstab` |
| Script runs with wrong privileges | SUID is **ignored on scripts** by Linux kernel | wrap in compiled binary or use sudo policy |

## 14. Monitoring & auditing
- **Baseline** the SUID/SGID set and file perms of `/etc`, then diff on a schedule.
- **auditd watches** (module 12) on privileged files:
```
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k priv
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
```
- **FIM** (AIDE/Tripwire, module 14) alerts on any mode/owner change of critical files.
- **osquery**: `SELECT path,uid,gid,mode FROM suid_bin;` for fleet-wide SUID inventory.

## 15. Logging
Permission *changes* aren't logged by default — you must add auditd rules (above). Failed
accesses hit the app/syslog, not the kernel, unless audited. Key logs: `/var/log/audit/
audit.log` (auditd), `journalctl` for service-level denials. Retain ≥ 1 year for
PCI/HIPAA; forward to a WORM/SIEM so an attacker who gains root can't erase evidence.

## 16. Disaster recovery & backup
- Back up **permission metadata**, not just contents: `getfacl -R /etc > acls.bak`,
  restore with `setfacl --restore=acls.bak`. `tar --acls --xattrs -p` preserves ACLs,
  SUID bits, and xattrs (SELinux labels) — plain `cp` may not.
- Keep a signed **golden baseline** of `/etc` perms to restore after a compromise.
- After restoring from backup, **re-verify SUID inventory** — malware plants SUID shells.

## 17. Common interview questions (signature)
- *Why can a SUID root program be dangerous, and why does Linux ignore SUID on shell
  scripts?* (Shell scripts create a race/`#!` interpreter substitution attack window;
  the kernel refuses to honor SUID on interpreted files.)
- *A directory is `777` — how do I let users create files but not delete each other's?*
  (Sticky bit → `1777`.)

## 18. Common mistakes engineers make
- `chmod 777` "to make it work" — almost always wrong; find the real owner/group need.
- `chmod -R 755 /` type fat-finger — nukes `/etc/shadow` perms and breaks the system.
- Adding SUID to fix a permission problem instead of using `sudo`/capabilities/ACLs.
- Assuming `ls -l` shows everything — **missing the `+`** that signals ACLs.
- Copying files with `cp` and losing SUID/xattrs/SELinux labels in a restore.
- Loosening `umask` globally to fix one app.

## 19. Advanced concepts
- **File capabilities** replace SUID granularly: `setcap cap_net_bind_service=+ep prog`
  lets a non-root binary bind port 80 without full root (deep dive in module 10 / K8s
  capabilities). Inspect with `getcap -r / 2>/dev/null`.
- **Default ACLs** on directories (`setfacl -d`) auto-apply to new children — powerful
  for shared trees.
- **The SGID-on-directory + group inheritance** interplay with `umask` and `fs.protected_*`
  sysctls.
- **Namespaced UIDs (user namespaces):** in containers, "root" (uid 0) can be mapped to
  an unprivileged host uid — SUID inside the container maps to that unprivileged uid on
  the host (foundation of rootless containers, Docker module 05).
- **`nosuid` mount option** neutralizes all SUID on a filesystem — standard hardening for
  `/tmp`, `/home`, `/var` (module 10).

## 20. Production examples — banking / fintech / healthcare / cloud-native
- **Banking (core-banking host):** golden image ships with a **frozen, minimal SUID
  inventory**; CIS-benchmarked; auditd watches on `/etc/shadow`, `/etc/sudoers`; any new
  SUID file triggers a SIEM alert and an automated host quarantine. `umask 077`.
- **Fintech (PCI cardholder data env):** app config owned `root:app` mode `640`; the app
  user has **read-only** ACL, no write; secrets `600`; world-writable files = a failing
  control in the quarterly ASV/PCI scan.
- **Healthcare (ePHI file store):** POSIX ACLs grant per-clinician access to record
  directories (need-to-know, HIPAA §164.312); default ACLs propagate to new records;
  access changes audited for the 6-year HIPAA retention window.
- **Cloud-native (container base image):** Dockerfiles run `find / -perm -4000` at build
  and **strip unneeded SUID bits**; images run as non-root with `readOnlyRootFilesystem`
  so even a planted SUID bit can't be written (ties to Docker module 07, K8s module 07).

---

## 📝 Summary
- DAC = owner/group/other × r/w/x, stored in the inode; the **first matching class wins**.
- Special bits: **SUID** (run as file owner), **SGID** (run as group / dir group
  inheritance), **sticky** (only owner can delete in a shared dir).
- SUID-root binaries are the top local-privesc vector → minimize, baseline, monitor.
- Prefer **capabilities** and **ACLs** over SUID and `777`.
- Harden with restrictive `umask`, `nosuid` mounts, auditd watches, and FIM.

## 🧪 Hands-on Lab — Exploit & remediate a SUID misconfiguration
> Run in a disposable VM/container. See [`labs/lab-suid-privesc.md`](labs/lab-suid-privesc.md).

```bash
# --- SETUP (as root) — create a vulnerable SUID binary ---
useradd -m lowpriv
cp /usr/bin/find /usr/local/bin/find-backup
chmod 4755 /usr/local/bin/find-backup     # SUID root find == privesc

# --- ATTACK (as lowpriv) ---
su - lowpriv
find / -perm -4000 -type f 2>/dev/null     # discover SUID binaries -> spot find-backup
/usr/local/bin/find-backup . -exec /bin/sh -p \; -quit   # -p keeps euid=0
id                                          # euid=0(root)  <-- ESCALATED
exit

# --- DETECT (as root/blue team) ---
find / -perm -4000 -type f 2>/dev/null      # inventory; diff vs baseline
ausearch -k perm_mod 2>/dev/null            # if auditd rule was set, see the chmod

# --- REMEDIATE ---
chmod u-s /usr/local/bin/find-backup        # or rm it
# Add the auditd watch so next time it's caught:
auditctl -a always,exit -F arch=b64 -S chmod,fchmodat -F auid>=1000 -k perm_mod
```
**Expected result:** step 2 gives you a root shell (`euid=0`); step 4 shows how to find
and kill it. Record the SUID baseline so drift is detectable.

## 🔧 Troubleshooting Exercise
A teammate reports: *"I own the file, `ls -l` shows `-rw-rw-rw-`, but I get Permission
denied opening it."* You run `ls -l` and see `-rw-rw-rw-+`. **What's going on and how do
you confirm & fix it?** (Hint: the `+`.)
<details><summary>Answer</summary>
The `+` means a POSIX ACL is present and is *further restricting* (or the effective
rights mask is limiting) access despite the friendly mode bits. Run `getfacl file`, look
at the `mask::` line and any `user:` entries; fix with `setfacl -m u:youruser:rw file`
or adjust the mask `setfacl -m m::rw file`. The mode bits alone lie when an ACL exists.
</details>

## ❓ Quiz
1. What octal mode is `-rwsr-xr-x`?
2. A dir is `drwxrwxrwt`. What does the `t` do and what mode is it?
3. You `chmod 000` a file you own. Can you still read it? Can you `chmod` it back? Why?
4. Why does Linux ignore the SUID bit on `#!/bin/bash` scripts?
5. Which command lists all SUID files on the root filesystem only (not other mounts)?
6. What's the difference between SGID on a *file* vs on a *directory*?
7. You see `-rw-r--r--+`. What does the `+` mean?
8. How do you replace SUID `ping` with a capability?
9. Which mount option neutralizes SUID, and where would you use it?
10. Why is a world-writable directory *without* the sticky bit dangerous?

## 🎤 Interview Questions
**Beginner:** Explain the meaning of each character in `-rwxr-x---`. What is `umask` and
what does `umask 022` produce for a new file?
**Intermediate:** Walk me through exactly what the kernel does when process P (uid 1000,
groups {dev}) calls `open()` on a file owned by uid 1000, group dev, mode `0640`. Now
mode `0604` — does the group get to read? Why not?
**Advanced:** How would you inventory and reduce the SUID attack surface across a 5,000-
host fleet, detect drift in near-real-time, and prove it for a PCI audit? How do file
capabilities and user namespaces change the risk model?

## 🏭 Production Scenario
Your SIEM fires: a new SUID-root binary `/dev/shm/.x` appeared on a payments host at
02:14. Walk the response: (1) confirm via `find`/auditd who/what created it and the
parent process, (2) contain (isolate host, snapshot memory & disk — module 17), (3) hunt
for the entry vector (was `/dev/shm` `noexec`? should be), (4) eradicate, (5) harden:
mount `/dev/shm` `noexec,nosuid,nodev`, add auditd `chmod` rule, re-baseline SUID set,
(6) report against your IR runbook and PCI incident requirements.

## 📌 Assignment / Mini-project
Write a hardening + audit script (`suid-guardian.sh`) that: (a) snapshots the current
SUID/SGID/world-writable inventory to a signed baseline, (b) on later runs diffs against
the baseline and exits non-zero on drift, (c) auto-remediates a configurable allowlist of
"strip SUID from these" binaries, (d) emits JSON suitable for a SIEM. Bonus: package it as
a systemd timer and map each finding to a CIS control id.

---
### ✅ Quiz Answers
<details><summary>Reveal</summary>

1. `4755` (SUID + rwxr-xr-x).
2. Sticky bit — only a file's owner (or dir owner/root) may delete/rename files in it;
   mode `1777`.
3. You can't read it (owner class matched, no `r`), but you **can** `chmod` it back
   because `chmod` needs *ownership*, not read permission.
4. Race/interpreter-substitution attacks between the SUID check and the interpreter
   reading the file (`#!` handling) make it unsafe; the kernel refuses SUID on interpreted
   scripts.
5. `find / -xdev -perm -4000 -type f 2>/dev/null` (`-xdev` = don't cross filesystems).
6. On a file: run as the file's group (setgid). On a directory: new files inherit the
   directory's group (and new subdirs inherit the SGID bit).
7. A POSIX ACL exists beyond the standard owner/group/other bits.
8. `setcap cap_net_raw+ep /usr/bin/ping && chmod u-s /usr/bin/ping`.
9. `nosuid`; use it on `/tmp`, `/var/tmp`, `/dev/shm`, `/home` (module 10).
10. Any user can delete/rename *anyone's* files in it (delete is a directory-write op),
    enabling file-swap and symlink attacks.
</details>
