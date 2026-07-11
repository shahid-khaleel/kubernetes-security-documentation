# Lab — Default-Deny Firewall
1. Load `examples/nftables.conf` (`nft -f`). Confirm only 22/80/443 + established allowed.
2. Prove SSH rate-limit: rapid new connections get dropped.
3. Add egress filtering; block all outbound except DNS+HTTPS.
**Deliverable:** ruleset + a blocked port + rate-limit evidence.
