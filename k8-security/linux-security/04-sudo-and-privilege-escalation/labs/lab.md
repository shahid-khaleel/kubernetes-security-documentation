# Lab — sudo Least Privilege + GTFOBins
1. Apply `examples/sudoers-least-privilege.conf` (validate with `visudo -cf`).
2. ATTACK: give a user `sudo vi` then `:!/bin/sh` → root shell (GTFOBins). Remove it.
3. Confirm the scoped rule only allows the two systemctl commands.
**Deliverable:** show the GTFOBins escape, then the least-privilege fix.
