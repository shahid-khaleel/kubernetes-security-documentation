#!/usr/bin/env bash
# Stream Docker daemon events (container create/exec/mount) for monitoring.
docker events --filter type=container \
  --format '{{.Time}} {{.Action}} {{.Actor.Attributes.name}} {{.Actor.Attributes.image}}'
