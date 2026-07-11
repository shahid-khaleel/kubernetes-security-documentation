# Lab — Compromised Container Triage
1. Start a container, simulate compromise (drop a file, open a port).
2. `examples/container-triage.sh <container>` → collect inspect/diff/top/logs/export, then pause.
3. Identify what changed via `docker diff`; export fs for offline analysis.
**Deliverable:** an evidence bundle + a short RCA of what changed.
