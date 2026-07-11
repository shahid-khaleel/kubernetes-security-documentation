# 05 — Rootless Docker

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** NIST 800-190, CIS Docker 2.x

**Objectives:** run dockerd + containers as an unprivileged user; understand the isolation gain and the limitations.

## Concept
**Rootless Docker** runs the daemon and containers entirely as a **non-root user** using
**user namespaces** (container uid 0 maps to your unprivileged host uid) and **slirp4netns**
for networking. The big win: a container escape or daemon bug lands on an **unprivileged
uid**, not host root — dramatically shrinking blast radius. Ideal for dev boxes, CI runners,
and shared build hosts.

## Risks / limitations (not a silver bullet)
- Still shares the host kernel (kernel LPE can still escalate, but from unprivileged start).
- Limitations: binding ports <1024 needs extra config, some storage drivers/features differ,
  `--privileged`/host devices restricted. Overlay/network perf caveats.

## Best practices & hardening
- Prefer rootless for dev/CI and untrusted builds. Combine with non-root-in-container, caps
  dropped, seccomp. Setup: [examples/setup-rootless.sh](examples/setup-rootless.sh).
- For prod K8s, the equivalent is running workloads non-root + userns (K8s 07/09).

## Compliance
| NIST 800-190 | CIS Docker 2.x | ISO A.8.2 |
|---|---|---|
| least privilege runtime | daemon not root | privileged access |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What maps uid 0 to unprivileged? A limitation? Does it stop kernel escapes? **Interview —** *B:* What is rootless Docker? *I:* Isolation gain vs root Docker. *A:* Where rootless does/doesn't remove risk. **Scenario:** CI shares docker.sock (root) → migrate runners to rootless (or Kaniko), verify builds work, confirm escape no longer yields host root.
