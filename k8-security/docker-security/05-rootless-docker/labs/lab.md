# Lab — Rootless Docker
1. `examples/setup-rootless.sh`; confirm `docker info` shows rootless.
2. Inside a container `id` = root(0), but on host the process runs as your uid (`ps -o user`).
3. Show a limitation: binding port <1024 needs extra config.
**Deliverable:** proof daemon+container run unprivileged on the host.
