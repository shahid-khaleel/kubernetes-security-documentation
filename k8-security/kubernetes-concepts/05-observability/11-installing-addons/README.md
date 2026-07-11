# Installing Addons

**What it is.** Cluster addons extend core functionality: CNI (Calico/Cilium), DNS (CoreDNS),
ingress controllers, CSI drivers, metrics-server, dashboards, operators. Installed via
manifests/Helm/operators.

**Why it matters (security).** Addons often run **highly privileged** (host network, node
access, broad RBAC, hostPath) — they're a prime **supply-chain and privilege-escalation**
target. A malicious/vulnerable addon = cluster compromise (e.g. an over-permissioned dashboard,
a backdoored Helm chart).

**Best practices**
- **Vet the source**; pin/scan/sign addon images ([supply chain](../../../kubernetes-security/17-image-security-and-signing-cosign-sigstore/)); review the RBAC/hostPath/caps each addon requests.
- Prefer least-privilege; avoid cluster-admin addons; namespace-isolate; keep addons patched.
- Verify Helm charts (provenance); apply admission policy to addon workloads too.
- Be wary of the **Kubernetes Dashboard** — secure or avoid; never expose it unauthenticated.
**Cross-links:** [Admission Controllers](../../../kubernetes-security/05-admission-controllers/), [Extending Kubernetes](../../07-extending-kubernetes/), [RBAC Good Practices](../../01-security/09-rbac-good-practices/).
