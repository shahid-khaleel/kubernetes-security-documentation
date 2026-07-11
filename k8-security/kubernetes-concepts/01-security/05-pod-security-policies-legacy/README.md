# Pod Security Policies (Legacy — Removed)

**What it is.** PSP was the original in-cluster pod-hardening admission mechanism. It was
**deprecated in 1.21 and removed in 1.25**, replaced by **Pod Security Admission** (PSS) and
policy engines (Kyverno/Gatekeeper).

**Why it's here.** You'll still meet PSP in old clusters, docs, and interview questions, and
you may need to **migrate** off it.

**Why PSP was replaced:** confusing "authorize the policy then the pod" RBAC model, ordering
ambiguity when multiple PSPs matched, and it was easy to misconfigure into fail-open.

**Migration path**
| PSP feature | Replacement |
|---|---|
| Baseline/restricted enforcement | **Pod Security Admission** (namespace labels) |
| Fine-grained/custom rules, mutation, exceptions | **Kyverno** or **OPA Gatekeeper** |
| Allowed capabilities/volumes/runAsUser | PSS Restricted + SecurityContext + admission policy |

**Best practices:** migrate to PSA Restricted + Kyverno; don't build new PSP.
**Cross-links:** [PSA](../03-pod-security-admission/), [Admission Controllers](../../../kubernetes-security/05-admission-controllers/).
