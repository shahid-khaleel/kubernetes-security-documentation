# Good Practices for DRA (Cluster Admin)

**What it is.** Admin-side guidance for operating **Dynamic Resource Allocation** safely:
managing DeviceClasses, vetting drivers, and controlling who can claim hardware.

**Why it matters (security).** DRA drivers are **privileged host components**, and hardware
handed to pods (GPUs/NICs) carries escape/side-channel risk. Admins own the trust decisions.

**Good practices**
- **Vet & pin DRA driver images** (scan/sign); least-privilege RBAC for the driver's SA; review
  the host access each driver needs.
- **Curate DeviceClasses**; restrict `resourceclaims` creation to approved namespaces via RBAC.
- **Isolate** hardware-sharing tenants (dedicated nodes/pools; side-channel awareness).
- **Quota** device usage; **audit** ResourceClaim lifecycle; monitor driver health.
- Keep drivers patched; test failure modes (driver crash shouldn't strand workloads insecurely).

**Cross-links:** [Scheduling/09 — DRA](../../03-scheduling-preemption-eviction/09-dynamic-resource-allocation/), [Hardening DRA](../../01-security/13-hardening-dynamic-resource-allocation/).
