# Lab — Kubelet Hardening
1. Probe the kubelet read-only port (should be closed): `curl -sk https://NODE:10250/pods` (expect 401),
   `curl -s http://NODE:10255/pods` (should refuse — readOnlyPort 0).
2. Apply `examples/kubelet-config-hardened.yaml`, restart kubelet.
3. Confirm anonymous auth is off: `curl -sk https://NODE:10250/pods` → `Unauthorized`.
**Deliverable:** curl outputs proving anonymous + read-only port are disabled.
