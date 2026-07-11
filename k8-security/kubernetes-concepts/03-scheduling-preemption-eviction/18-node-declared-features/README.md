# Node Declared Features

**What it is.** Nodes advertise their capabilities/features (kernel features, OS, runtime
handlers, extended resources, labels) so the scheduler and admins can make **capability-aware**
placement decisions — e.g. only nodes that support a given seccomp/AppArmor/RuntimeClass run
certain pods.

**Why it matters (security).** Security features aren't uniform across a heterogeneous fleet
(Windows vs Linux, kernels, LSMs, sandboxed runtimes). Declared features let you **guarantee a
pod only lands on a node that can actually enforce its security requirements** (e.g. AppArmor
support, gVisor handler).

**Example — schedule only onto nodes advertising a runtime/label**
```yaml
spec:
  runtimeClassName: gvisor        # scheduler places only on nodes with the gvisor handler
  nodeSelector: { kubernetes.io/os: linux, apparmor: "supported" }
```
**Best practices:** label nodes with security capabilities (LSM, runtimes); require them via
affinity/RuntimeClass so security fields aren't silently ignored (esp. Linux vs Windows).
**Cross-links:** [Linux kernel constraints](../../01-security/16-linux-kernel-security-constraints/), [Security for Windows Nodes](../../01-security/07-security-for-windows-nodes/), [Pod Overhead/RuntimeClass](../04-pod-overhead/).
