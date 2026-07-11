# Lab — Pod Security Admission
1. Label a namespace: `kubectl apply -f examples/namespace-psa-restricted.yaml`.
2. Deploy a privileged pod there → rejected with a clear PSA violation list.
3. Deploy `examples/restricted-compliant-pod.yaml` → succeeds.
4. Flip enforce→audit/warn to see non-blocking modes.
**Deliverable:** the rejection output enumerating which restricted controls failed.
