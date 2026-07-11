# Lab — Brute-Force Defense
1. Apply `examples/jail.local`; `fail2ban-client status sshd`.
2. From another host, fail SSH 5× → IP banned (`fail2ban-client status sshd`).
3. Unban: `fail2ban-client set sshd unbanip <ip>`.
**Deliverable:** a ban event + jail status.
