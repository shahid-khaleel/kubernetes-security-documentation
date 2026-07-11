# Lab — Zero-Trust Network Policies
> Needs a CNI that enforces policy (Calico/Cilium). kind: `kind create cluster` then install Calico.
1. Baseline: two pods can talk (`kubectl exec frontend -- curl -s api:8080`).
2. Apply `examples/default-deny-all.yaml` → traffic (and DNS) now blocked.
3. Apply `examples/allow-frontend-to-api-and-dns.yaml` → only frontend→api:8080 + DNS work.
4. Prove isolation: a third pod cannot reach api.
**Deliverable:** curl successes/failures showing default-deny + explicit allow.
