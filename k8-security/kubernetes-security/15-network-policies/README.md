# 15 — Network Policies (Zero-Trust Networking)

> **Track:** Kubernetes Security · **Level:** 🔴 · **Refs:** CIS K8s 5.3.x, NSA/CISA, PCI 1.x, NIST SC-7

**Objectives:** implement default-deny + explicit allow; control ingress/egress; understand CNI enforcement (Calico/Cilium).

## 1–5. Concept
By default, **every pod can talk to every other pod** — a flat network ideal for lateral
movement. **NetworkPolicies** are namespaced firewall rules (pod/namespace selectors + ports)
that restrict pod traffic. They're **additive and default-allow until a policy selects a pod**,
then default-deny for the selected direction. **Enforcement requires a policy-aware CNI**
(Calico, Cilium) — the API object alone does nothing on a CNI that ignores it.
```
 no policy:      any ─► any        (flat, lateral movement easy)
 default-deny +  frontend ─► api:8080 only ; everything else (and DNS) blocked unless allowed
 explicit allow
```

## 6–7. Risks & attacks
- Flat networking → **lateral movement** after one pod compromise (T1021). No egress control →
  data exfil / C2. Forgetting DNS egress after a default-deny breaks the app (a classic gotcha).

## 9–10. Best practices & hardening
- **Default-deny ingress+egress per namespace** ([examples/default-deny-all.yaml](examples/default-deny-all.yaml)),
  then explicit allows incl. **DNS** ([examples/allow-frontend-to-api-and-dns.yaml](examples/allow-frontend-to-api-and-dns.yaml)).
- Restrict egress to known destinations; isolate tenants/tiers; use Cilium for **L7** policy.
  Audit namespaces lacking any policy ([../../scripts/k8s-quick-audit.sh](../../scripts/k8s-quick-audit.sh)).

## 11. Compliance
| CIS 5.3.x | PCI 1.x | ISO A.8.20/22 | NIST SC-7 | NSA/CISA |
|---|---|---|---|---|
| network policy | segmentation | network security | boundary | default-deny |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** Default pod-to-pod behavior? What enforces policies? Why allow DNS egress? **Interview —** *B:* What is a NetworkPolicy? *I:* Write default-deny + an allow. *A:* Zero-trust network design for multi-tenant + egress control. **Scenario:** compromised web pod scanned the whole cluster → apply default-deny, explicit allows, egress allowlist, verify lateral movement is blocked.
