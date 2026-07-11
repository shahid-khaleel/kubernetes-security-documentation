# Lab — Containers Are Namespaces
1. Run `examples/namespace-demo.sh`; compare `/proc/<pid>/ns` host vs container.
2. `unshare --user --map-root-user --net --pid --fork bash` to build a mini-container by hand.
3. Enable userns-remap (`examples/daemon-userns-remap.json`), restart dockerd, re-check that
   container uid 0 maps to a high host uid (`cat /proc/<pid>/uid_map`).
**Deliverable:** side-by-side ns list + uid_map proving remap.
