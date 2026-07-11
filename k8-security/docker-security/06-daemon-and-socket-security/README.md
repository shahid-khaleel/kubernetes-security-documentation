# 06 — Docker Daemon & Socket Security

> **Track:** Docker Security · **Level:** 🔴 · **Refs:** CIS Docker 2.x/3.x, NIST 800-190

**Objectives:** treat the socket/daemon as root; secure remote API with mTLS; harden daemon.json; block socket mounts.

## Concept
`dockerd` runs as **root** and listens on `/var/run/docker.sock`. **Anyone who can reach the
socket controls a root daemon** — and can trivially get host root. The `docker` group grants
socket access, so it **is** a root-equivalent group. Remote API over TCP must use **mTLS**
(port 2376); plain `2375` is remote root.

## Risks & attacks (a top real-world finding)
- **Socket mounted into a container** → `docker run -v /:/host --privileged … chroot /host`
  → HOST ROOT ([examples/docker-sock-escape.md](examples/docker-sock-escape.md)). MITRE T1610.
- **API on `tcp://0.0.0.0:2375`** (no TLS) → mass-exploited for cryptomining.
- Over-broad `docker` group membership; unpatched daemon.

## Best practices & hardening
- **Never** mount the socket into workloads/CI; use rootless/BuildKit/Kaniko or a scoped proxy.
- If remote API needed: **mTLS only** (2376). Harden [examples/daemon.json](examples/daemon.json):
  `userns-remap`, `no-new-privileges`, `icc:false`, `live-restore`. auditd-watch `/etc/docker` + socket.
- Access reviews: treat `docker` group as privileged.

## Compliance
| CIS Docker 2.x/3.x | PCI 7.x | ISO A.8.2 | NIST AC-6 |
|---|---|---|---|
| daemon/socket config | least privilege | privileged access | least privilege |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) (socket escape attack+prevent). **Quiz:** Why is the socket root-equivalent? Safe way to expose the API? Is `docker` group == root? **Interview —** *B:* What is docker.sock? *I:* Demonstrate the socket escape. *A:* Secure a CI/CD platform that needs to build images without socket exposure. **Scenario:** exposed 2375 with miners → firewall, kill miners, switch to mTLS, harden daemon, add scanning/admission gate.
