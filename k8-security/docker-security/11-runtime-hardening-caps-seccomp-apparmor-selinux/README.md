# 11 — Runtime Hardening (Capabilities, seccomp, AppArmor, SELinux)

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** CIS Docker 5.x, NIST 800-190

**Objectives:** drop capabilities, enforce seccomp, apply LSM profiles, read-only rootfs, no-new-privileges.

## Concept
Even a non-root container has power via **Linux capabilities**, syscalls, and writable paths.
Runtime hardening minimizes each: **`--cap-drop=ALL`** then add back only what's needed;
**seccomp** filters syscalls (Docker's default blocks ~44 dangerous ones); **AppArmor/SELinux**
apply MAC confinement; **`--read-only`** + tmpfs makes the rootfs immutable;
**`--security-opt=no-new-privileges`** blocks setuid escalation. Together = defense-in-depth.

## Risks it reduces
- Capability abuse (`SYS_ADMIN`, `NET_RAW`, `DAC_OVERRIDE`), dangerous syscalls, writable
  binaries/config (persistence), setuid privesc. Reduces container-escape opportunities.

## Best practices & hardening
- The gold-standard run: [examples/hardened-run.sh](examples/hardened-run.sh) —
  `--cap-drop=ALL --cap-add=NET_BIND_SERVICE --read-only --tmpfs --security-opt=no-new-privileges
  --security-opt seccomp=... --user 10001 --pids-limit`. AppArmor profile: [examples/apparmor-docker-nginx.profile](examples/apparmor-docker-nginx.profile).
- Never `--privileged`. Verify caps with `capsh --print`.

## Compliance
| CIS Docker 5.x | PCI 2.2 | ISO A.8.22 | NIST AC-6/SC-39 |
|---|---|---|---|
| caps/seccomp/apparmor | secure config | segregation | least priv/isolation |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does `--cap-drop=ALL` do? seccomp default effect? What does `no-new-privileges` stop? **Interview —** *B:* Name three runtime hardening flags. *I:* Build a hardened `docker run`. *A:* Map these to K8s SecurityContext + admission. **Scenario:** container ran `--privileged` in prod → replace with drop-ALL+add-one, seccomp, read-only, verify app still works, block privileged at admission.
