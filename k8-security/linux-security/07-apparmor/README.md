# 07 — AppArmor

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS (Ubuntu), NIST AC-3

**Objectives:** write & load path-based profiles; use complain→enforce; confine apps and containers.

## Concept
**AppArmor** is a MAC LSM (default on Ubuntu/SUSE) that confines programs via **path-based**
profiles (`/etc/apparmor.d/`) rather than SELinux's label-based types — simpler to author,
less granular. A profile lists exactly which files/capabilities/network a binary may use;
anything else is denied. Modes: **enforce** (block+log) and **complain** (log only, for
building profiles). Docker uses AppArmor to confine containers (`--security-opt apparmor=...`).

## Risks & attacks
- Unconfined daemons run with full DAC power. No profile = no MAC protection.
- Path-based profiles can be bypassed via alternate paths/bind mounts if written loosely.
- Disabling/`complain` in prod removes enforcement. Overly permissive rules defeat the point.

## Best practices & hardening
- Enforce profiles for internet-facing/high-risk apps; deny `/etc/shadow`, writable binaries.
- Build with `aa-genprof`/`aa-logprof` in complain mode, then switch to enforce (`aa-enforce`).
- Confine containers (Docker module 11). Examples: [examples/usr.sbin.myapp.profile](examples/usr.sbin.myapp.profile). Status: `aa-status`.

## Compliance
| CIS | PCI 2.2 | ISO A.8.22 | NIST AC-3/SC-39 |
|---|---|---|---|
| MAC enabled | secure config | segregation | mandatory access |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** AppArmor vs SELinux model? enforce vs complain? How build a profile from behavior? **Interview —** *B:* What is AppArmor? *I:* Confine an app and verify denials. *A:* AppArmor vs SELinux trade-offs for a container platform. **Scenario:** confine a new web app: complain-mode → collect logs → tighten → enforce → verify /etc/shadow read is denied.
