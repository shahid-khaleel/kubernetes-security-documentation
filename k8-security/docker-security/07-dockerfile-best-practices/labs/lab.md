# Lab — Fix the Bad Dockerfile
1. Build `examples/Dockerfile.bad`; run `docker history` → find the leaked `DB_PASSWORD` in a layer.
2. Scan it with Trivy (module 09) → many CVEs + secret finding.
3. Rewrite it into `examples/Dockerfile.hardened` + add `.dockerignore`. Re-scan → clean(er), non-root.
**Deliverable:** before/after scan + `docker history` proving the secret is gone.
