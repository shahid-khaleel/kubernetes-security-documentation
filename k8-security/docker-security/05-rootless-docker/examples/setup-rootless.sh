#!/usr/bin/env bash
# Rootless Docker: daemon + containers run as an unprivileged user (no root dockerd).
set -euo pipefail
sudo apt-get install -y uidmap dbus-user-session slirp4netns
dockerd-rootless-setuptool.sh install
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
docker run --rm alpine id      # container root maps to your unprivileged host uid
echo "Escape from a rootless container lands on an unprivileged uid, not host root."
