# Dynamic Resource Allocation (DRA)

**What it is.** A flexible API (`ResourceClaim`, `ResourceClaimTemplate`, `DeviceClass`) for
requesting and sharing **specialized hardware** (GPUs, FPGAs, NICs) via third-party drivers —
successor to the device-plugin model.

**Why it matters (security).** DRA **drivers are privileged** (host device access, often
DaemonSets); ResourceClaims can grant powerful device access with escape/side-channel
potential. New API surface = new RBAC to scope.

**Example (concept)**
```yaml
apiVersion: resource.k8s.io/v1beta1
kind: ResourceClaimTemplate
metadata: { name: gpu, namespace: ml }
spec:
  spec:
    devices:
      requests: [{ name: gpu, deviceClassName: nvidia-gpu }]
```
**Best practices:** treat drivers as privileged (scan/sign/pin, least-priv RBAC); restrict
which namespaces create claims; isolate hardware-sharing tenants; audit claim creation.
**Cross-links:** [Hardening DRA](../../01-security/13-hardening-dynamic-resource-allocation/), [DRA Admin Good Practices](../../05-observability/02-dra-good-practices-cluster-admin/).
