# 05 — Admission Controllers (OPA/Gatekeeper, Kyverno)

> **Track:** Kubernetes Security · **Level:** ⚫ · **Refs:** CIS K8s 1.2.x, NSA/CISA, NIST CM-3/CM-7

**Objectives:** use validating/mutating webhooks to enforce policy-as-code (block bad workloads, mutate defaults, verify signatures).

## 1–5. Concept
**Admission controllers** intercept API requests **after authN/authZ but before persistence**
— the last gate to *enforce policy on what gets created*. Built-in ones (NodeRestriction,
PodSecurity) plus **dynamic webhooks**: **validating** (allow/deny) and **mutating** (modify,
e.g. inject sidecars/defaults). Policy engines **OPA Gatekeeper** (Rego constraints) and
**Kyverno** (YAML policies) let you require non-root, block privileged, restrict registries,
require labels, and **verify image signatures** — all rejected at admission.

## 6–7. Risks & attacks
- Without admission policy, RBAC-permitted users create privileged/hostPath pods → escape (T1610/T1611).
- Webhook **failurePolicy=Ignore** or an unavailable webhook → policies silently bypassed
  ("fail open"). Overly-permissive/mutating webhooks can weaken security. Webhook is a new attack surface.

## 9–10. Best practices & hardening
- Enforce baseline guardrails: no privileged, runAsNonRoot, drop caps, approved registries,
  signed images. Kyverno: [examples/kyverno-require-signed-and-nonroot.yaml](examples/kyverno-require-signed-and-nonroot.yaml);
  Gatekeeper: [examples/gatekeeper-constrainttemplate-repos.yaml](examples/gatekeeper-constrainttemplate-repos.yaml).
- Start **Audit** → soak → **Enforce**. Secure the webhook (TLS, RBAC, `failurePolicy=Fail` for security policies). Pair with PSA (module 06).

## 11. Compliance
| CIS 1.2.x | PCI 6.5 | ISO A.8.32 | NIST CM-3/CM-7 | SOC2 CC8.1 |
|---|---|---|---|---|
| admission plugins | change control | change mgmt | config change/least fn | change mgmt |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Validating vs mutating? When does admission run? Risk of `failurePolicy=Ignore`? **Interview —** *B:* What is an admission controller? *I:* Write a policy to block privileged pods. *A:* Design policy-as-code governance (audit→enforce, exceptions, signature verification). **Scenario:** privileged pods keep appearing → deploy Kyverno enforce policy, add signed-image verification, wire into CI, monitor policy reports.
