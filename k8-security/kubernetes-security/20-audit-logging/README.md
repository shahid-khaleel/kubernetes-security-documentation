# 20 — Audit Logging

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 1.2.x/3.2.x, PCI 10.x, NIST AU-2/6/9

**Objectives:** write an audit policy (levels/stages), enable it on the apiserver, ship logs to a SIEM, alert on high-risk events.

## Concept
The **API server audit log** records **who did what** to the cluster — the authoritative trail
for forensics and compliance. An **audit Policy** sets the **level** (None/Metadata/Request/
RequestResponse) per resource/verb and which **stages** to log. Tune it for **high signal, low
noise**: log `exec`/`attach`, RBAC/admission changes at full detail; secrets at Metadata (never
dump values); skip chatty system reads.

## Risks it addresses
- No trail → can't reconstruct a breach or prove compliance. Local-only logs → attacker deletes
  them (T1070). Over-logging secrets = a new leak; under-logging = blind spots.

## Best practices & hardening
- Production policy: [examples/audit-policy-production.yaml](examples/audit-policy-production.yaml) (also the lab
  cluster's [../../labs/audit-policy.yaml](../../labs/audit-policy.yaml)). Enable on apiserver
  (`--audit-policy-file`,`--audit-log-*`). **Ship off-cluster** (fluent-bit → SIEM); WORM retention.
- **Alert** on: exec into pods, cluster-admin/CRB creation, `impersonate`, `403` spikes, secret access.

## Compliance
| CIS 3.2.x | PCI 10.x | ISO A.8.15 | NIST AU-2/6/9 | HIPAA 164.312(b) |
|---|---|---|---|---|
| audit policy | log & monitor | logging | audit/protect | audit controls |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Four audit levels? Why log secrets at Metadata only? Why ship off-cluster? **Interview —** *B:* What is the audit log? *I:* Write a policy capturing exec + RBAC changes. *A:* Tamper-evident audit pipeline + detection rules. **Scenario:** breach suspected, need the timeline → query audit log for the actor's requests; if local-only was wiped, motivate SIEM shipping + immutable retention.
