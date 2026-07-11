# Lab — Build Secrets Without Leaks
1. BAD: pass a secret via `--build-arg` → find it in `docker history`.
2. GOOD: build `examples/Dockerfile.buildsecret` with `--secret` → NOT in history/layers.
3. Verify: `docker history --no-trunc <img> | grep -i secret` → nothing.
**Deliverable:** proof the build secret is absent from the final image.
