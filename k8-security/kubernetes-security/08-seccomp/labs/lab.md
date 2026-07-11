# Lab — Seccomp Profiles
1. Deploy `examples/pod-seccomp-runtimedefault.yaml`; confirm `Seccomp: 2` (filtered) in
   `grep Seccomp /proc/1/status` inside the pod.
2. Deploy a pod with the custom `examples/audit.json` (Localhost profile placed under the
   node's seccomp dir); watch a blocked syscall fail with EPERM.
**Deliverable:** proof the default profile is active + a denied-syscall error.
