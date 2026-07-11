# 10 — Docker Secrets Management

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** PCI 3.x/8.x, NIST IA-5/SC-28

**Objectives:** keep secrets out of images/env/history; use BuildKit `--secret` and runtime secret stores.

## Concept
Secrets (API keys, DB creds, tokens) must never be **baked into images** (layers/`docker
history` leak them) or passed as plain **`ENV`/build-args** (visible in `inspect`/history).
Options: **BuildKit build secrets** (`--mount=type=secret`, not persisted), **Docker/Swarm
secrets** (tmpfs-mounted files), and **external stores** (Vault, cloud secret managers) at runtime.

## Risks & attacks
- Secrets in images/registry → anyone who pulls the image gets them (T1552.001). Env-var
  leakage via `/proc/<pid>/environ`, crash logs, `docker inspect`. Build-arg leakage in history.

## Best practices & hardening
- Build-time: BuildKit `--secret` ([examples/Dockerfile.buildsecret](examples/Dockerfile.buildsecret)).
  Never `ENV SECRET=`. Runtime: mount from a secret store; short-lived/rotatable.
- Verify: `docker history --no-trunc IMG | grep -i secret` returns nothing. Rotate on exposure.

## Compliance
| PCI 3.x/8.x | ISO A.5.17 | NIST IA-5/SC-28 | HIPAA 164.312(a) |
|---|---|---|---|
| protect/authN secrets | secret mgmt | authenticator/data | access control |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Why not `ENV` for secrets? What does `--secret` avoid? Where do env vars leak? **Interview —** *B:* How do secrets leak into images? *I:* Use a build secret without leaking it. *A:* End-to-end secret handling build→runtime with rotation. **Scenario:** token found in a layer → rotate, rebuild with `--secret`, move runtime creds to Vault, verify history is clean.
