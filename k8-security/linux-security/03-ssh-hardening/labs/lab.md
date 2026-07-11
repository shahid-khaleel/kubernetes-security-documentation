# Lab — Harden sshd (keep a backup session open!)
1. Deploy `examples/sshd_config.hardened`; validate `sshd -t`; reload.
2. Confirm root login + password auth are refused; key auth works.
3. Audit crypto: `ssh -Q cipher`, `nmap --script ssh2-enum-algos -p22 <host>`.
**Deliverable:** proof password/root login disabled + strong ciphers only.
