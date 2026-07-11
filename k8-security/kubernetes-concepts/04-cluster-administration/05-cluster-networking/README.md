# Cluster Networking

**What it is.** The K8s network model: every pod gets a routable IP; all pods can reach all
pods **by default** (flat network); Services provide stable VIPs; a **CNI** plugin
(Calico/Cilium/etc.) implements pod networking and (optionally) NetworkPolicy enforcement.

**Why it matters (security).** "All pods can talk to all pods" is the default that enables
**lateral movement** after a single compromise. Networking is where you impose zero-trust:
NetworkPolicy, mTLS, and egress control. Not all CNIs enforce policy — choose one that does.

```
pod A ─┐                       Default: A↔B↔C all reachable (flat)
pod B ─┼─ CNI (Calico/Cilium)  Hardened: default-deny + explicit allow + egress control
pod C ─┘                                  + mTLS (mesh) for identity
```
**Best practices**
- Use a **policy-enforcing CNI** (Calico/Cilium); default-deny NetworkPolicies ([sec/15](../../../kubernetes-security/15-network-policies/)).
- **Egress control** + block the cloud metadata endpoint ([API bypass](../../01-security/15-api-server-bypass-risks/)).
- Encrypt pod-to-pod (Cilium/WireGuard or mesh mTLS — [sec/16](../../../kubernetes-security/16-istio-and-mtls/)); segment namespaces/tenants.
- Secure ingress (TLS, WAF); limit `hostNetwork`/`hostPort`.
**Cross-links:** [Network Policies](../../../kubernetes-security/15-network-policies/), [Istio/mTLS](../../../kubernetes-security/16-istio-and-mtls/), [Proxies in Kubernetes](../../05-observability/09-proxies-in-kubernetes/).
