#!/usr/bin/env bash
# See the layers of the Docker stack: client -> dockerd -> containerd -> shim -> runc.
set -euo pipefail
docker info | grep -E 'Server Version|Storage Driver|Cgroup|Runtimes|Default Runtime'
docker run -d --name demo nginx:1.27-alpine >/dev/null
echo "== containerd sees the container =="; sudo ctr -n moby containers ls 2>/dev/null | head
echo "== process tree (note containerd-shim as parent, runc exits after start) =="
ps -ef | grep -E 'dockerd|containerd|shim|nginx' | grep -v grep
docker rm -f demo >/dev/null
