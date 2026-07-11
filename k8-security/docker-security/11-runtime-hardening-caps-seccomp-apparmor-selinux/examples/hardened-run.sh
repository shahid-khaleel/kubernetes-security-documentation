#!/usr/bin/env bash
# The "gold standard" hardened docker run.
docker run -d --name web \
  --read-only --tmpfs /tmp --tmpfs /var/run \
  --cap-drop=ALL --cap-add=NET_BIND_SERVICE \
  --security-opt=no-new-privileges \
  --security-opt seccomp=/etc/docker/seccomp/default.json \
  --security-opt apparmor=docker-nginx \
  --pids-limit=200 --memory=256m --cpus=0.5 \
  --user 10001:10001 \
  nginx:1.27-alpine
