# Lab — Gold-Standard Hardened Run
1. Run `examples/hardened-run.sh`. Verify caps: `docker exec web capsh --print`.
2. `docker exec web touch /x` → read-only fs blocks it.
3. Drop seccomp to `unconfined` and try a blocked syscall to see the difference.
**Deliverable:** caps/seccomp/read-only all verified from inside the container.
