# Lab — AppArmor in Kubernetes
1. Load a profile on the node: `sudo apparmor_parser -r -W k8s-deny-write` (deny writes).
2. Deploy `examples/pod-apparmor.yaml`; inside the pod `echo x > /etc/x` → Permission denied.
3. `aa-status` on the node shows the container process confined.
**Deliverable:** the denied write + aa-status confinement line.
