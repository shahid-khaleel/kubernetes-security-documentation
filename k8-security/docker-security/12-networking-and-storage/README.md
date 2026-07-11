# 12 — Docker Networking & Storage Security

> **Track:** Docker Security · **Level:** 🟡 · **Refs:** CIS Docker 5.x/7.x, NIST SC-7

**Objectives:** segment networks; disable inter-container comms by default; secure volumes/bind mounts; use tmpfs for secrets.

## Concept
Docker networking (bridge/host/none/overlay) controls container connectivity. By default the
bridge allows **inter-container communication (icc)** — disable it and use explicit user-defined
networks to **segment tiers** (a DB should not share a network with a public web front-end).
Storage: **named volumes** vs **bind mounts** (host paths — dangerous if root-owned/sensitive);
**tmpfs** keeps secrets in memory only.

## Risks & attacks
- Flat network → lateral movement between containers (T1021). `icc=true` lets a compromised
  container reach every other. **Bind-mounting host paths** (`/`, `/etc`, docker.sock) → escape/exposure.
- World-writable volumes; secrets on disk instead of tmpfs.

## Best practices & hardening
- `icc=false`; user-defined networks per tier; `internal: true` for no-egress backends
  ([examples/isolated-network-compose.yaml](examples/isolated-network-compose.yaml)).
- Prefer named volumes; bind-mount read-only (`:ro`); never mount sensitive host paths; tmpfs for secrets.

## Compliance
| CIS Docker 5.x/7.x | PCI 1.x | ISO A.8.20/22 | NIST SC-7 |
|---|---|---|---|
| network/volume config | segmentation | network security | boundary |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What is icc and why disable it? Named volume vs bind mount? Why `internal: true`? **Interview —** *B:* Docker network types? *I:* Segment a 3-tier app. *A:* Prevent lateral movement + protect data-at-rest in containers. **Scenario:** compromised web container reached the DB directly → segment networks, `icc=false`, make backend internal, verify DB unreachable from web tier.
