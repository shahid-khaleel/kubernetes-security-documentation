# 07 — Dockerfile Best Practices

> **Track:** Docker Security · **Level:** 🟢 · **Refs:** CIS Docker 4.x, NIST 800-190

**Objectives:** build least-privilege, pinned, secret-free images; use USER/`.dockerignore`; avoid layer leaks.

## Concept
The Dockerfile defines the image — and most container risk is baked in at **build time**:
whether it runs as root, what's inside (attack surface), whether secrets leaked into layers,
and whether versions are pinned/reproducible. Layers are **immutable and inspectable**
(`docker history`), so a secret added then "removed" still lives in an earlier layer.

## Risks & attacks
- **Secrets in `ENV`/`ARG`/`COPY`** → leaked forever in layers/registry (T1552).
- Running as **root**; `chmod 777`; `curl | sh` from the network; unpinned `latest`
  (non-reproducible, supply-chain risk); copying `.git`/`.env` (no `.dockerignore`).
  See the annotated [examples/Dockerfile.bad](examples/Dockerfile.bad).

## Best practices & hardening
- `USER` non-root; pin base **by digest**; multi-stage (module 08); `--secret` for build creds
  (module 10); `.dockerignore` for `.git/.env/*.key`; remove package caches; minimal packages.
- Golden template: [examples/Dockerfile.hardened](examples/Dockerfile.hardened) +
  [examples/.dockerignore](examples/.dockerignore). Scan every build (module 09).

## Compliance
| CIS Docker 4.x | PCI 6.x | ISO A.8.28 | NIST SA-15 |
|---|---|---|---|
| image build hygiene | secure dev | secure coding | dev process |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) — find the leaked secret via `docker history`, then fix. **Quiz:** Why not `ENV` for secrets? Why pin by digest? What does `.dockerignore` prevent? **Interview —** *B:* Why run as non-root? *I:* Review a bad Dockerfile. *A:* Enforce Dockerfile hygiene across many teams (linting + admission). **Scenario:** password found in a published image → rotate it, rebuild with `--secret`, purge/rebuild tags, add build-time scanning to block recurrence.
