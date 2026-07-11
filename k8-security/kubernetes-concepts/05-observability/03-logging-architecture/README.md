# Logging Architecture

**What it is.** How logs flow in K8s: containers write to **stdout/stderr** → the container
runtime writes node files → a **node-level agent** (Fluent Bit/Fluentd/Vector as a DaemonSet)
ships them to a backend (Elasticsearch/Loki/SIEM). Kubernetes itself does **not** provide
cluster-wide log storage.

**Why it matters (security).** Logs are **evidence**. If they stay only on nodes/containers,
an attacker with node/pod access deletes them (T1070). Centralized, **immutable** logging is
required for IR and compliance (PCI 10, HIPAA).

```
app stdout ─► runtime (node file) ─► node agent (DaemonSet) ─► central store / SIEM (immutable)
```
**Best practices**
- Deploy a node logging agent; **ship off-cluster to WORM/immutable** storage; set retention
  (PCI ≥1yr, HIPAA ≥6yr).
- Include **API audit logs** ([sec/20](../../../kubernetes-security/20-audit-logging/)) and **runtime alerts** (Falco) in the pipeline.
- Don't log secrets/PII; scrub sensitive fields; protect the logging pipeline's credentials.
- Structured (JSON) logs for detection/correlation.
**Cross-links:** [System Logs](../07-system-logs/), [Audit Logging](../../../kubernetes-security/20-audit-logging/), [Runtime Security](../../../kubernetes-security/19-runtime-security-falco-ebpf/).
