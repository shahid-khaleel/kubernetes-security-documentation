# Traces for Kubernetes System Components

**What it is.** **Distributed tracing** (OpenTelemetry/OTLP) for control-plane components —
the apiserver and kubelet can emit traces of request handling, exported to an OTel collector
→ Jaeger/Tempo. Enabled via a `TracingConfiguration`.

**Why it matters (security/availability).** Traces reveal **request latency and flow** through
the API pipeline — useful to diagnose admission-webhook slowness (an availability/DoS risk),
API-priority throttling, and to reconstruct the sequence of a suspicious operation for IR.

**Example — apiserver tracing config**
```yaml
apiVersion: apiserver.config.k8s.io/v1beta1
kind: TracingConfiguration
endpoint: otel-collector:4317
samplingRatePerMillion: 100      # sample; avoid overhead + leaking sensitive detail
```
**Best practices:** sample (don't full-trace prod); secure the OTLP endpoint (mTLS); ensure
traces don't capture secret payloads; use for latency/DoS diagnosis + IR timelines.
**Cross-links:** [Metrics — System Components](../05-metrics-for-system-components/), [API Priority & Fairness](../10-api-priority-and-fairness/), [Admission Webhook Good Practices](../01-admission-webhook-good-practices/).
