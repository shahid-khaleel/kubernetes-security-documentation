# Lab — RBAC Least Privilege + Escalation Hunt
1. Apply `examples/role-least-privilege.yaml`. Test with impersonation:
   `kubectl auth can-i delete pods -n payments --as dev-alice` → no
   `kubectl auth can-i get pods -n payments --as dev-alice` → yes
2. ATTACK: apply `examples/dangerous-rbac-antipatterns.yaml`, then from a pod using the
   `default` SA run `kubectl auth can-i '*' '*'` → yes (takeover). Delete it.
3. Hunt cluster-wide: `kubectl get clusterrolebindings -o json | jq -r '.items[]|select(.roleRef.name=="cluster-admin")|.subjects'`.
**Deliverable:** list of over-privileged bindings + your remediation.
