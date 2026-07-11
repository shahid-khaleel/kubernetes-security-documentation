# 13 — Docker Logging & Monitoring

> **Track:** Docker Security · **Level:** 🟡 · **Refs:** CIS Docker, PCI 10.x, NIST AU-2/SI-4

**Objectives:** choose/rotate log drivers; stream daemon events; feed runtime telemetry to monitoring/SIEM.

## Concept
Containers are ephemeral — their stdout/stderr go to a **log driver** (json-file default;
also syslog, journald, fluentd, awslogs). Without shipping, logs die with the container.
**`docker events`** exposes lifecycle/security-relevant actions (create, exec, mount, kill).
Security monitoring needs both **app logs** and **runtime telemetry** centralized off-host.

## Risks it addresses
- Lost evidence when containers exit/are deleted (T1070). Disk-fill from unrotated json logs.
- Blind spots: `docker exec` into prod, unexpected mounts/privileged starts.

## Best practices & hardening
- Rotate json-file (`max-size`,`max-file`) or ship to fluentd/SIEM. Stream + alert on
  `docker events` ([examples/watch-events.sh](examples/watch-events.sh)), esp. `exec`/`--privileged`.
- Centralize immediately (host root can wipe local logs). Add runtime detection (Falco, K8s 19).

## Compliance
| PCI 10.x | ISO A.8.15/16 | NIST AU-2/SI-4 | SOC2 CC7.2 |
|---|---|---|---|
| log & monitor | logging/monitoring | audit/monitoring | detection |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Default log driver? Why ship logs off-host? What does `docker events` show? **Interview —** *B:* Where do container logs go? *I:* Set up log rotation + forwarding. *A:* Design container observability for IR. **Scenario:** an attacker `exec`'d into prod and deleted the container → had events+logs been shipped, you'd have the trail; implement forwarding + exec alerts.
