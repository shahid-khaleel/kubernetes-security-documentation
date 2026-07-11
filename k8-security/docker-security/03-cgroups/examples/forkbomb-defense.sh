#!/usr/bin/env bash
# Demonstrate pids-limit stopping a fork bomb (LAB ONLY, in a container).
set -euo pipefail
echo "Without limit a fork bomb can take the host. With --pids-limit it is contained:"
docker run --rm --pids-limit=50 alpine sh -c ':(){ :|:& };: ' || \
  echo "Fork bomb hit the pids cap and failed to exhaust host — GOOD."
