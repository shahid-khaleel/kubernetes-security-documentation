# System Logs

**What it is.** Logs from Kubernetes **components** themselves: control-plane (apiserver,
scheduler, controller-manager, etcd — often static-pod container logs) and node (**kubelet**,
container runtime) logs, typically via **systemd/journald** on nodes (`journalctl -u kubelet`),
with adjustable **klog** verbosity (`-v`).

**Why it matters (security).** Component logs record authN/authZ decisions, admission actions,
kubelet operations, and errors — vital for **forensics** and debugging security incidents.
They must be shipped off-node (an attacker with node root deletes them).

**Where to look**
```bash
journalctl -u kubelet -u containerd            # node
kubectl logs -n kube-system kube-apiserver-<node>   # control-plane static pod
crictl logs <container-id>                      # runtime-level
```
**Best practices:** forward journald/component logs to the central pipeline
([Logging Architecture](../03-logging-architecture/)); set sensible klog verbosity (too high
can leak tokens/PII into logs); retain per compliance.
**Cross-links:** [Logging Architecture](../03-logging-architecture/), [Audit Logging](../../../kubernetes-security/20-audit-logging/), [Linux/12 — journald/rsyslog](../../../linux-security/12-auditd-journald-rsyslog/).
