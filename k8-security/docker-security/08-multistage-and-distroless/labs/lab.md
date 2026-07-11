# Lab — Shrink the Attack Surface
1. Build a normal image vs `examples/Dockerfile.go-scratch`; compare `docker images` sizes.
2. `docker run --rm <distroless> sh` → fails (no shell = fewer escape tools).
3. Trivy scan both → distroless/scratch has far fewer CVEs.
**Deliverable:** size + CVE-count comparison table.
