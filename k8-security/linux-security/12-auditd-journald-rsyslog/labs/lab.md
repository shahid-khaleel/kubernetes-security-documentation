# Lab — Tamper-Evident Auditing
1. Load `examples/audit.rules` (`augenrules --load`).
2. Edit /etc/passwd → `ausearch -k identity` shows who/when.
3. Forward logs to a remote rsyslog so a local root can't erase them.
**Deliverable:** audit trail of a sensitive change + remote copy.
