# 15 — Docker Incident Response

> **Track:** Docker Security · **Level:** ⚫ · **Refs:** PCI 12.10, NIST IR-4, MITRE ATT&CK Containers

**Objectives:** triage a compromised container without destroying evidence; capture fs/process/network state; contain & eradicate.

## Concept
Container IR adapts host IR to ephemeral, image-based workloads. Key idea: **don't just
`docker rm`** — that destroys evidence. Freeze and collect first: `docker inspect` (config/
mounts/caps), **`docker diff`** (what changed vs the image — a great signal), `docker top`,
`docker logs`, `docker export` (full fs), then `docker pause`. Because images are immutable,
**eradication = redeploy from a clean, signed image** after fixing the entry vector.

## What you look for
- Filesystem changes (`docker diff`), unexpected processes/listeners (reverse shells),
  mounted `docker.sock`/host paths (escape attempts), added SUID, modified entrypoints,
  outbound C2/mining. Map to **MITRE ATT&CK for Containers**.

## Best practices & procedures
- Collect-then-contain: [examples/container-triage.sh](examples/container-triage.sh) (inspect/diff/
  top/logs/export/pause). Capture **host** memory too (container procs are host procs).
- Rotate all secrets the container could access; rebuild from golden image; patch the vector.

## Compliance
| PCI 12.10 | ISO A.5.24-27 | NIST IR-4/5 | HIPAA 164.308(a)(6) |
|---|---|---|---|
| IR plan | incident mgmt | IR handling | response |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Why not `docker rm` first? What does `docker diff` show? Why capture host memory? **Interview —** *B:* First steps on a suspect container? *I:* Run a container triage. *A:* Full container IR incl. host forensics + ATT&CK mapping. **Scenario:** Falco flags a reverse shell in a pod's container → collect evidence (diff/export/logs), capture host RAM, contain via NetworkPolicy+cordon (K8s 26), rotate creds, redeploy signed image, RCA.
