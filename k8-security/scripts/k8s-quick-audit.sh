#!/usr/bin/env bash
# k8s-quick-audit.sh — fast RBAC/workload posture checks with kubectl+jq (read-only).
set -euo pipefail
echo "== cluster-admin bindings (should be few, human-only) =="
kubectl get clusterrolebindings -o json | jq -r \
  '.items[]|select(.roleRef.name=="cluster-admin")|"\(.metadata.name): \(.subjects//[]|map(.kind+"/"+.name)|join(","))"'
echo; echo "== pods running as root / privileged / hostPath =="
kubectl get pods -A -o json | jq -r '.items[] |
  select((.spec.containers[].securityContext.privileged==true)
     or ((.spec.securityContext.runAsNonRoot//false)==false)
     or ((.spec.volumes//[])|any(.hostPath))) |
  "\(.metadata.namespace)/\(.metadata.name)"' | sort -u
echo; echo "== pods that automount SA tokens (review need) =="
kubectl get pods -A -o json | jq -r '.items[] |
  select((.spec.automountServiceAccountToken//true)==true) |
  "\(.metadata.namespace)/\(.metadata.name)"' | head
echo; echo "== namespaces WITHOUT Pod Security 'restricted' enforce =="
kubectl get ns -o json | jq -r '.items[] |
  select((.metadata.labels["pod-security.kubernetes.io/enforce"]//"none")!="restricted") |
  .metadata.name'
echo; echo "== namespaces WITHOUT any NetworkPolicy =="
for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  n=$(kubectl get netpol -n "$ns" --no-headers 2>/dev/null | wc -l)
  [ "$n" -eq 0 ] && echo "  $ns (no NetworkPolicy!)"
done
