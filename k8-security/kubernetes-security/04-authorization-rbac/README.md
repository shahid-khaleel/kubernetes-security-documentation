# 04 — Kubernetes Authorization & RBAC

> **Track:** Kubernetes Security · **Level:** 🔴 Advanced (CKS-heavy)
> **Prerequisites:** [K8s AuthN](../03-authentication/), [Linux permissions](../../linux-security/01-permissions-acls-suid-sgid-sticky/)
> **Est. time:** 5–6 hrs · **Refs:** CIS K8s 5.1.x, NSA/CISA Hardening, NIST AC-6

**Learning objectives — after this lesson you can:**
- [ ] Explain how the API server decides *authorize* after *authenticate*.
- [ ] Write least-privilege Roles/ClusterRoles and bind them correctly.
- [ ] Use `kubectl auth can-i` (incl. `--as`) to test and audit permissions.
- [ ] Identify and remediate privilege-escalation paths (escalate/bind/impersonate,
      pods+exec, secrets, workload-controller abuse).
- [ ] Audit a cluster for over-privileged subjects.

---

## 1. What it is
**RBAC (Role-Based Access Control)** is Kubernetes' primary **authorization** mechanism:
after a request is *authenticated* (module 03), RBAC decides whether that identity may
perform a **verb** (get/list/watch/create/update/patch/delete/…) on a **resource**
(pods, secrets, deployments…) in a **scope** (a namespace or cluster-wide). It's expressed
as four objects: **Role** and **ClusterRole** (what may be done) plus **RoleBinding** and
**ClusterRoleBinding** (who may do it).

## 2. Why it exists
Early Kubernetes shipped **ABAC** (attribute policy files on disk) — clunky, required API
server restarts to change, easy to get wrong. RBAC (GA in 1.8) made authorization a set of
**API objects** you manage declaratively with `kubectl`/GitOps, versioned and auditable,
changeable live. It maps cleanly to the principle of **least privilege** — the core of
every compliance framework.

## 3. The problem it solves
Without authorization, any authenticated identity (a user, or a **pod's ServiceAccount**)
could read every Secret, delete any workload, or grant itself more power. RBAC lets you
give the CI deployer exactly `create/update deployments in ns=app` and nothing else, and
give a monitoring agent read-only access — so a **compromised pod or leaked token** has a
tightly bounded blast radius.

## 4. How it works internally
Every request to the API server passes through a chain:

```
   Request ─► AuthN (who are you?) ─► AuthZ (are you allowed?) ─► Admission ─► etcd
                                         │
              --authorization-mode=Node,RBAC   (evaluated in order; FIRST allow wins)
```

- **AuthZ modes** run in order (e.g. `Node,RBAC`). If *any* authorizer **allows**, the
  request proceeds. RBAC never *denies* explicitly — it's **default-deny**: if no rule
  allows, and no other authorizer allows, the request is `Forbidden (403)`.
- **RBAC evaluation:** the authorizer gathers the subject's **username + groups** (from
  AuthN) or the **ServiceAccount** identity, finds all bindings referencing that subject,
  unions the rules from the referenced Roles/ClusterRoles, and checks if any rule matches
  `(verb, apiGroup, resource, resourceName?, namespace)`. **Rules are purely additive —
  there are no deny rules.** More access is granted only by adding bindings.
- **Role vs ClusterRole:** a `Role` is namespaced (rules apply in its namespace); a
  `ClusterRole` is cluster-scoped and can also be *reused* per-namespace via a RoleBinding.
- **Binding rules:** a `RoleBinding` can reference a Role (same ns) *or* a ClusterRole
  (grants that ClusterRole's verbs, but only within the binding's namespace). A
  `ClusterRoleBinding` + ClusterRole grants **cluster-wide** — the dangerous combination.

## 5. Architecture
```
        SUBJECTS                    "WHO"  ──bind──►  "WHAT"            SCOPE
   ┌─────────────────┐        ┌──────────────────┐   ┌───────────┐
   │ User (cert/OIDC)│        │  RoleBinding      │──►│   Role     │  namespaced
   │ Group           │───────►│  (namespaced)     │   └───────────┘
   │ ServiceAccount  │        └──────────────────┘         ▲
   └─────────────────┘        ┌──────────────────┐   ┌─────┴──────┐
                              │ ClusterRoleBinding│──►│ClusterRole │  cluster-wide
                              │  (cluster-wide)   │   └───────────┘
                              └──────────────────┘   (also usable via RoleBinding
                                                       to scope it to one namespace)

   Rule = { apiGroups:[""], resources:["pods"], verbs:["get","list"], resourceNames?:[...] }
   Evaluation: DEFAULT DENY. Additive rules only. First authorizer to ALLOW wins.
```

## 6. Security risks
- **`cluster-admin` sprawl** — bound to users, groups, or (worst) **ServiceAccounts**.
  A pod using such an SA = full cluster takeover from a single container compromise.
- **Wildcards** — `verbs:["*"]`, `resources:["*"]`, `apiGroups:["*"]` grant far more than
  intended (including future resources).
- **The `default` ServiceAccount** is mounted into pods by default; if it (or its
  namespace) has broad rights, every pod inherits them.
- **Escalation verbs:** `escalate`, `bind`, `impersonate`, and write access to RBAC
  objects let a subject grant itself more than it has.
- **Indirect escalation:** `create pods` (or deployments/jobs/etc.) + a privileged podSpec
  → run a pod that mounts the host or uses a powerful SA. `get secrets` → read credentials.
  `create tokenrequest`/`serviceaccounts/token` → mint tokens for other SAs.
- **`system:masters` group** bypasses RBAC entirely (hard-coded superuser) — guard the
  certs that carry it.

## 7. Common attacks (MITRE ATT&CK)
- **T1078 Valid Accounts:** steal a ServiceAccount token from a pod
  (`/var/run/secrets/...`) and use its RBAC rights to pivot.
- **T1548 / privilege escalation via RBAC:** find a Role granting `create` on
  `rolebindings`/`clusterrolebindings` and `bind` → bind yourself to `cluster-admin`.
- **Secret theft:** `get/list secrets` cluster-wide → dump all credentials, then move
  laterally to cloud/databases.
- **Workload-based escape:** `create pods` in a namespace without Pod Security restricted
  → schedule a privileged/hostPath pod and escape to the node.
- **Impersonation:** `impersonate` users/groups → act as `system:masters`.

## 8. Real-world production use cases
- **Team namespaces:** developers get a namespaced Role (`edit`-like, minus secrets/RBAC);
  bound to their OIDC group.
- **CI/CD deployer:** a ServiceAccount with `create/update/patch` on
  deployments/services/configmaps in one namespace — nothing cluster-wide.
- **Monitoring/agents:** read-only ClusterRole (`get/list/watch` on metrics-relevant
  resources) via ClusterRoleBinding.
- **Break-glass admin:** `cluster-admin` bound to a small, audited human group, ideally
  behind just-in-time access + MFA.

## 9. Best practices
1. **Default-deny is the friend — grant, don't ungrant.** Start from zero.
2. **Namespaced Roles over ClusterRoles** whenever the scope is one namespace.
3. **Never bind `cluster-admin` (or wildcards) to a ServiceAccount.** Rarely to humans.
4. **Prefer groups over individual users** for human RBAC (via OIDC), so offboarding is
   one identity-provider change.
5. **Scope with `resourceNames`** when a subject needs only specific objects (e.g. one
   Secret).
6. **Disable `automountServiceAccountToken`** unless the pod truly calls the API
   ([module 11](../11-service-accounts/)); pair RBAC with token hygiene.
7. **Review the escalation verbs** (`escalate`, `bind`, `impersonate`) — grant almost never.
8. **Audit continuously** (§14) and gate RBAC changes through code review/GitOps + admission.

## 10. Hardening techniques
```bash
# What can a subject do? (impersonation-based testing — the core audit tool)
kubectl auth can-i --list --as=dev-alice --as-group=developers -n payments
kubectl auth can-i delete pods -n payments --as=dev-alice           # yes/no
kubectl auth can-i '*' '*' --as=system:serviceaccount:default:default

# Find cluster-admin (and wildcard) grants
kubectl get clusterrolebindings -o json | jq -r \
 '.items[]|select(.roleRef.name=="cluster-admin")|"\(.metadata.name): \(.subjects//[]|map(.kind+"/"+.namespace//""+"/"+.name)|join(","))"'

# Find ClusterRoles that contain wildcards (dangerous)
kubectl get clusterroles -o json | jq -r \
 '.items[]|select([.rules[]?|select((.verbs|index("*")) or (.resources|index("*")))]|length>0)|.metadata.name'

# Find who can read secrets cluster-wide
kubectl get clusterrolebindings,rolebindings -A -o json | jq -r '..|.roleRef?|select(.)' # then inspect roles

# Apply a least-privilege role (examples/)
kubectl apply -f examples/role-least-privilege.yaml
```
Automated auditor: [`../../scripts/k8s-quick-audit.sh`](../../scripts/k8s-quick-audit.sh).
Tools: **rbac-tool** (`rbac-tool who-can get secrets`), **kubescape** RBAC view,
**krane**, **kubectl-who-can**.

## 11. Compliance requirements
| Framework | Control | Requirement |
|-----------|---------|-------------|
| CIS K8s | 5.1.1–5.1.6 | Minimize cluster-admin, wildcard, secret access; avoid `system:masters` |
| NSA/CISA | Authentication & Authorization | Enforce least-privilege RBAC, unique identities |
| PCI DSS 4.0 | 7.2, 7.3 | Least privilege / need-to-know; deny-by-default |
| ISO 27001 | A.5.15, A.8.2 | Access control, privileged access management |
| SOC 2 | CC6.1, CC6.3 | Logical access least privilege + periodic review |
| NIST 800-53 | AC-2, AC-3, AC-6 | Account mgmt, access enforcement, least privilege |
| HIPAA | §164.308(a)(4) | Information access management |

## 12. Performance considerations
RBAC evaluation is in-memory and fast; the authorizer caches Roles/Bindings via informers.
Pathological cases: thousands of bindings referencing wildcard ClusterRoles increase the
rule set the authorizer unions per request — keep roles tight and few. Frequent
`SubjectAccessReview` calls (from dashboards) add API load; cache results.

## 13. Troubleshooting techniques
| Symptom | Diagnosis | Fix |
|---------|-----------|-----|
| `Forbidden` but should work | no binding, or wrong scope (Role vs ClusterRole) | `kubectl auth can-i ... --as`; add correct binding |
| Works but shouldn't | over-broad ClusterRoleBinding / wildcard | tighten role, remove binding |
| SA in pod has surprise access | inherited via `default` SA or namespace binding | scope SA, disable automount |
| Binding "does nothing" | subject name/namespace mismatch (SA needs namespace) | fix `subjects[].namespace` |
| `can-i` says yes, API says no | another authorizer (Node/webhook) or admission blocks | check admission (module 05) |

## 14. Monitoring & auditing
- **Audit logs** ([module 20](../20-audit-logging/)) at `RequestResponse` for RBAC objects
  — every create/update/delete of Roles/Bindings, plus `Forbidden` decisions (`403`) which
  reveal probing.
- **Alert on:** any binding to `cluster-admin`; creation of ClusterRoleBindings; use of
  `impersonate`; spikes in `403`s from one identity.
- **Periodic access review:** export `kubectl auth can-i --list` per SA/group into an
  evidence report (SOC2/PCI need this quarterly).

## 15. Logging
RBAC decisions surface in the **API server audit log** (`authorization.k8s.io/decision`
annotation shows `allow`/`forbid` and the reason/rule). `Forbidden` responses are logged
with the user, verb, and resource — high-signal for detecting stolen-token misuse. Ship to
SIEM; retain per framework (PCI ≥ 1yr).

## 16. Disaster recovery & backup
RBAC objects live in **etcd** — covered by etcd snapshots and Velero
([module 24](../24-backup-and-disaster-recovery/)). Best practice: manage all RBAC as
**code in Git** (GitOps) so the authoritative source is version-controlled and re-appliable;
etcd restore + `kubectl apply` rebuilds authorization deterministically. Keep a documented
**break-glass** procedure (a sealed `cluster-admin` cert) for when RBAC itself is broken.

## 17. Common interview questions (signature)
- *Difference between Role+RoleBinding, ClusterRole+RoleBinding, and ClusterRole+
  ClusterRoleBinding?* (namespaced / reuse-a-clusterrole-in-one-ns / cluster-wide.)
- *A pod's ServiceAccount token leaks. What's the blast radius and how do you limit it?*
  (Exactly the RBAC bound to that SA → scope it, disable automount, use bound tokens.)

## 18. Common mistakes engineers make
- Binding `cluster-admin` to fix a `Forbidden` instead of writing a scoped role.
- Wildcards (`*`) "to be safe" — the opposite of safe.
- Granting the `default` SA broad rights (every pod inherits it).
- Forgetting a ServiceAccount subject needs a `namespace` field in the binding.
- Not realizing `create pods` + weak Pod Security = node compromise (RBAC isn't the only gate).
- Testing RBAC only as cluster-admin (always test with `--as`).

## 19. Advanced concepts
- **Aggregated ClusterRoles** (`aggregationRule`) auto-compose from labeled roles — powerful
  but can silently widen access when a new labeled role appears.
- **`SubjectAccessReview`/`SelfSubjectAccessReview`** APIs — how `can-i` and webhooks ask
  "is X allowed?" programmatically.
- **Webhook authorizers** — delegate authZ to an external service (e.g. OPA) after RBAC.
- **Node authorizer + NodeRestriction** — kubelets get scoped access to only their node's
  objects; essential to stop a compromised node reading all secrets.
- **Escalation prevention:** you can't create a Role with permissions you don't already
  hold, unless you have the `escalate` verb — the built-in guardrail (and its bypass).

## 20. Production examples — banking / fintech / healthcare / cloud-native
- **Banking:** human access is **OIDC group → namespaced Role**, JIT-elevated for
  break-glass; **zero** ServiceAccounts have cluster-wide write; every RBAC change is a
  reviewed GitOps PR validated by a Kyverno policy that **blocks cluster-admin bindings**
  and wildcards at admission.
- **Fintech (PCI 7.x):** quarterly automated access review exports `can-i --list` per
  identity as audit evidence; `403` spikes page the SOC; secrets access is `resourceNames`-
  scoped per app.
- **Healthcare (HIPAA):** need-to-know enforced by namespace-per-team + Roles that exclude
  `secrets` (secrets go through Vault, [module 14](../14-external-secrets-and-vault/));
  access to ePHI namespaces is logged and reviewed for the 6-year window.
- **Cloud-native SaaS:** per-tenant namespaces with identical scoped Roles rendered from a
  template; a tenant's SA can never see another tenant's objects (RBAC + NetworkPolicy +
  PSA together, [module 23](../23-multi-tenancy/)).

---

## 📝 Summary
- RBAC = **default-deny, additive-only** authorization: subjects → bindings → roles →
  (verb, resource, scope).
- The dangerous combos: **ClusterRoleBinding + cluster-admin/wildcards**, bound to a
  **ServiceAccount**.
- Escalation hides in `escalate`/`bind`/`impersonate`, `create pods`, and `get secrets`.
- Test and audit with `kubectl auth can-i --as`; enforce changes via GitOps + admission.
- Pair RBAC with **token hygiene** (module 11) and **Pod Security** (module 06) — RBAC
  alone doesn't stop workload-based escapes.

## 🧪 Hands-on Lab
See [`labs/lab.md`](labs/lab.md). Apply
[`examples/role-least-privilege.yaml`](examples/role-least-privilege.yaml), test with
`can-i --as`, then reproduce and remediate the takeover in
[`examples/dangerous-rbac-antipatterns.yaml`](examples/dangerous-rbac-antipatterns.yaml).

## 🔧 Troubleshooting Exercise
A developer says `kubectl get pods -n payments` returns `Forbidden`, but you "gave them
access." You find a `Role` named `pod-reader` in `payments` and a `RoleBinding` — but the
binding's subject is `kind: ServiceAccount, name: dev-alice` with no namespace, while
`dev-alice` is actually an OIDC **User**. Explain the two bugs and fix them.
<details><summary>Answer</summary>
(1) Wrong subject `kind` — should be `User`, not `ServiceAccount`. (2) Even for an SA,
`namespace` is required. Change the subject to `kind: User, name: dev-alice,
apiGroup: rbac.authorization.k8s.io`. Verify with `kubectl auth can-i get pods -n payments
--as dev-alice`.
</details>

## ❓ Quiz
1. Does RBAC have deny rules?
2. What identity does a pod use to call the API by default?
3. Which binding+role combo grants cluster-wide access?
4. How do you test what `system:serviceaccount:app:ci` can do?
5. Why is `create pods` a potential privilege-escalation permission?
6. What does the `escalate` verb allow?
7. Which group bypasses RBAC entirely?
8. Role vs ClusterRole — which is namespaced?
9. How do you scope a Secret grant to just one Secret?
10. Where do RBAC allow/deny decisions show up for auditing?

## 🎤 Interview Questions
**Beginner:** What is RBAC? Name the four RBAC objects and what each is for.
**Intermediate:** Walk through authN→authZ→admission for a `kubectl create deployment`.
How would you give a CI ServiceAccount exactly enough to deploy to one namespace?
**Advanced:** Enumerate every RBAC-based privilege-escalation path you can think of and how
you'd detect/prevent each at scale (admission policy, audit alerting, access reviews).

## 🏭 Production Scenario
Your audit log shows a ServiceAccount token from a crashed pod being used from an unusual
IP to `list secrets` across all namespaces at 03:00. Respond: confirm the SA's RBAC
(`can-i --list --as`), rotate the token + every secret it could read, revoke via deleting/
re-creating the SA, scope its Role to `resourceNames`, disable automount, add an audit
alert on cross-namespace secret listing, and write the RCA mapping to MITRE T1078/T1552.

## 📌 Assignment / Mini-project
Build `rbac-linter.sh` (kubectl + jq) that flags: any `cluster-admin`/wildcard binding, any
ServiceAccount with cluster-wide write, any Role granting `secrets` without `resourceNames`,
and any use of `escalate`/`bind`/`impersonate`. Output a scored report mapped to CIS K8s
5.1.x, and provide a Kyverno policy that **blocks** the worst offenders at admission.

---
### ✅ Quiz Answers
<details><summary>Reveal</summary>

1. No — RBAC is additive/allow-only with default-deny; you remove access by removing grants.
2. Its **ServiceAccount** (the namespace `default` SA unless specified), via a mounted token.
3. **ClusterRole + ClusterRoleBinding**.
4. `kubectl auth can-i --list --as=system:serviceaccount:app:ci`.
5. It lets you create a pod with a privileged/hostPath spec or a powerful SA and escape to
   the node — access to the resource implies the power of what you can put in it.
6. Creating/updating Roles with permissions **beyond** what you currently hold (bypasses the
   escalation guardrail).
7. `system:masters` (hard-coded superuser, bypasses RBAC).
8. `Role` is namespaced; `ClusterRole` is cluster-scoped.
9. `resourceNames: ["that-secret"]` in the rule (with `verbs:["get"]`).
10. The API server **audit log** (`authorization.k8s.io/decision` annotation: allow/forbid).
</details>
