#!/usr/bin/env bash
# Triage a suspect container WITHOUT destroying evidence.
set -euo pipefail
C="${1:?container id/name}"
docker inspect "$C" > "evidence-inspect-$C.json"     # config, mounts, caps
docker diff "$C"                                      # filesystem changes since image
docker top "$C"                                       # running processes
docker logs "$C" > "evidence-logs-$C.txt" 2>&1
docker export "$C" > "evidence-fs-$C.tar"             # full filesystem snapshot
docker pause "$C"                                     # freeze (don't rm) for forensics
echo "Frozen + evidence collected. Next: capture host memory, then eradicate."
