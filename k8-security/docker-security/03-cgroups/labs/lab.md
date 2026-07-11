# Lab — cgroups DoS Defense
1. `examples/forkbomb-defense.sh` — fork bomb contained by `--pids-limit`.
2. `docker run --memory=64m --rm polinux/stress stress --vm 1 --vm-bytes 128M` → OOM-killed, host safe.
3. Inspect: `cat /sys/fs/cgroup/<...>/memory.max`.
**Deliverable:** show fork bomb + memory hog contained without host impact.
