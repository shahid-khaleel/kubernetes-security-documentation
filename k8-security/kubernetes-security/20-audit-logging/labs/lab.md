# Lab — API Server Audit Logging
1. Cluster already boots with `../../../labs/audit-policy.yaml`. Apply the richer
   `examples/audit-policy-production.yaml` and restart apiserver.
2. Do a `kubectl exec` and an RBAC change; then grep the audit log for them:
   `sudo grep -E 'pods/exec|rolebindings' /var/log/kubernetes/audit/audit.log | jq .`
3. Ship logs off-cluster (fluent-bit → SIEM) so an attacker can't erase them.
**Deliverable:** audit entries for exec + an RBAC mutation.
