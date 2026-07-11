# Lab — Admission Policy with Kyverno
1. `kubectl apply -f https://github.com/kyverno/kyverno/releases/latest/download/install.yaml`
2. Apply `examples/kyverno-require-signed-and-nonroot.yaml`.
3. Try to deploy a privileged pod → BLOCKED at admission. Deploy the compliant pod (module 06) → allowed.
4. Add the allowed-registries policy (`examples/gatekeeper-...` or a Kyverno equivalent) and test.
**Deliverable:** the admission denial message + a passing deploy.
