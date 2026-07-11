# Lab — Harden Mounts
1. Apply `examples/fstab-hardened.conf` options to /tmp,/dev/shm; remount.
2. Prove `noexec`: drop a script in /tmp, `chmod +x`, run it → Permission denied.
3. `chattr +i /etc/resolv.conf`; try to edit → fails until `-i`.
**Deliverable:** the noexec block + immutable-file demo.
