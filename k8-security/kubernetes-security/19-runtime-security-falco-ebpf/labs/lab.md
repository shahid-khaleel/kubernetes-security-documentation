# Lab — Falco Runtime Detection
1. Install Falco (helm, `examples/falco-values.yaml`, modern_ebpf). Add `examples/falco-custom-rules.yaml`.
2. ATTACK: `kubectl exec -it <pod> -- bash` → Falco fires "Shell in container".
3. Write to /etc inside a pod → "Write below etc" ERROR alert.
4. Route alerts to Slack via falcosidekick.
**Deliverable:** the Falco JSON alerts for shell + /etc write.
