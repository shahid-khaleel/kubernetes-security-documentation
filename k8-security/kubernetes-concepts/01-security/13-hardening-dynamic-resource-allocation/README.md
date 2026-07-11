# Hardening Guide — Dynamic Resource Allocation (DRA)

**What it is.** DRA (beta/GA-track) lets pods request specialized hardware (GPUs, FPGAs,
NICs) via **ResourceClaims/DeviceClasses** and third-party **DRA drivers** — more flexible
than the old device-plugin model.

**Why it matters (security).** DRA introduces **new privileged components**: drivers often
run as DaemonSets with elevated host access, and ResourceClaims can grant powerful device
access (a GPU/NIC handed to a pod is a potential escape/side-channel path).

**Hardening**
- Treat DRA **drivers as privileged**: pin/scan/sign their images, least-privilege RBAC for
  the driver SA, restrict which namespaces may create ResourceClaims.
- Use **admission policy** to limit DeviceClasses per namespace/tenant.
- Isolate hardware-sharing tenants (side-channels); audit ResourceClaim creation.
- Keep drivers patched; review the host access each driver requires.

**Example — restrict who can claim a device class (concept)**
```yaml
# RBAC: only 'ml' namespace SAs may create resourceclaims referencing gpu classes
rules:
- apiGroups: ["resource.k8s.io"]
  resources: ["resourceclaims"]
  verbs: ["create","get","list"]
```
**Cross-links:** [Scheduling/09 — DRA](../../03-scheduling-preemption-eviction/09-dynamic-resource-allocation/), [Admission Controllers](../../../kubernetes-security/05-admission-controllers/).
