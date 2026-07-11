# 10 — Filesystem & Mount Security

> **Track:** Linux Security · **Level:** 🟡 · **Refs:** CIS 1.1.x, NIST CM-7/AC-3

**Objectives:** apply `noexec/nosuid/nodev`; separate partitions; use immutable attributes; harden temp dirs.

## Concept
Mount options and filesystem layout are cheap, high-value hardening. Separating `/tmp`,
`/var`, `/var/log`, `/home` onto their own mounts lets you apply restrictive options and
prevents one area filling `/`. **`noexec`** blocks running binaries from a mount (kills the
classic "drop payload in /tmp and run it"); **`nosuid`** neutralizes SUID; **`nodev`** blocks
device nodes. `chattr +i` makes critical files immutable even to root until cleared.

## Risks & attacks
- World-writable + exec `/tmp`/`/dev/shm` → attacker drops & runs payloads (T1036/T1059).
- SUID honored on user-writable mounts → privesc. Device-node creation in odd places.
- Disk-fill DoS when everything is one partition. Log tampering on writable `/var/log`.

## Best practices & hardening
- `/tmp`,`/var/tmp`,`/dev/shm`: `nosuid,nodev,noexec`. `/home`: `nosuid,nodev`. See [examples/fstab-hardened.conf](examples/fstab-hardened.conf).
- Separate partitions for `/var`, `/var/log`, `/tmp`, `/home`. `chattr +i` on key configs.
- Read-only root where possible (immutable infra/containers). Verify with `mount`/`findmnt`.

## Compliance
| CIS 1.1 | PCI 2.2 | ISO A.8.9 | NIST CM-7 |
|---|---|---|---|
| mount options/partitions | secure config | config mgmt | least functionality |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does `noexec` on /tmp stop? Why separate /var/log? What does `chattr +i` do? **Interview —** *B:* Name three mount hardening options. *I:* Why partition /tmp separately? *A:* Design an immutable host filesystem. **Scenario:** malware ran from /tmp → remount noexec/nosuid/nodev, separate partitions, add auditd watch, verify payload can no longer execute.
