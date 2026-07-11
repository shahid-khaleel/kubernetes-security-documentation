# Lab — Alternative Runtimes
1. Install gVisor; run `docker run --runtime=runsc alpine dmesg` (user-space kernel).
2. Compare syscall surface vs runc.
3. Read about CVE-2019-5736 (runc escape) — verify your runc version is patched: `runc --version`.
**Deliverable:** runsc vs runc comparison + patched runc version.
