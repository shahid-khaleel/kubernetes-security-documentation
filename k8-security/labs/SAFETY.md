# ⚠️ Lab Safety & Ethics

This curriculum contains **real attack demonstrations** (container escapes, privilege
escalation, credential theft, lateral movement). They exist so you learn to **detect
and prevent** them. Misuse is illegal and unethical.

## Rules
1. **Only attack systems you own or are contracted/authorized in writing to test.**
   Unauthorized access violates the CFAA (US), Computer Misuse Act (UK), IT Act (India),
   and equivalents everywhere.
2. **Isolate the lab.** Use a disposable VM or `kind` cluster. Prefer an isolated network
   / NAT. Do not run demos on a work laptop with corporate VPN/credentials present.
3. **No production, no shared clusters, no cloud accounts with real data.**
4. **Rotate/destroy anything sensitive** the labs generate (keys, certs, tokens).
5. **Tear down** after each session (`kind delete cluster`, `docker system prune -af`).

## Blast-radius checklist before any attack lab
- [ ] Am I in a VM/`kind` I can throw away?
- [ ] Are real credentials (cloud CLIs, kubeconfigs, SSH keys) absent from this host?
- [ ] Is the host off the corporate network or firewalled?
- [ ] Do I have a snapshot to roll back to?

## Responsible disclosure
If, while practicing, you discover a real vulnerability in a third-party product,
follow coordinated disclosure — report privately to the vendor, don't publish a
working exploit, don't test it against their production.
