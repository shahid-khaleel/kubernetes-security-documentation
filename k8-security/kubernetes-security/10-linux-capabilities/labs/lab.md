# Lab — Capabilities Drop/Add
1. Deploy `examples/pod-drop-all-add-one.yaml`; inside: `grep Cap /proc/1/status`,
   decode with `capsh --decode=<CapEff>` → only cap_net_bind_service.
2. ATTACK contrast: run a pod with `SYS_ADMIN` and mount something → shows why it's dangerous. Delete it.
**Deliverable:** decoded capability set before/after dropping ALL.
