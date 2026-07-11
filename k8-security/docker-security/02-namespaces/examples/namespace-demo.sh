#!/usr/bin/env bash
# Prove containers = namespaces. Compare namespaces of host vs container.
set -euo pipefail
docker run -d --name ns-demo alpine sleep 1h >/dev/null
PID=$(docker inspect -f '{{.State.Pid}}' ns-demo)
echo "Container PID on host: $PID"
echo "== host namespaces =="; sudo ls -l /proc/1/ns
echo "== container namespaces (differ for pid/net/mnt/uts/ipc) =="; sudo ls -l /proc/"$PID"/ns
echo "== user namespace test: is uid 0 in container the host root? =="
docker run --rm alpine id            # uid=0 inside
echo "Without userns-remap, that uid 0 == host root. Enable userns-remap to fix (see README)."
docker rm -f ns-demo >/dev/null
