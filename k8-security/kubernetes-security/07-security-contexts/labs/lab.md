# Lab — SecurityContext Hardening
1. Deploy `examples/securitycontext-hardened-deployment.yaml`.
2. Exec in and prove hardening: `id` (non-root), `touch /x` (read-only fs → fails),
   `cat /proc/1/status | grep CapEff` (caps dropped).
3. Try to escalate: run a setuid binary → blocked by allowPrivilegeEscalation:false.
**Deliverable:** command outputs proving non-root + read-only + no-privesc.
