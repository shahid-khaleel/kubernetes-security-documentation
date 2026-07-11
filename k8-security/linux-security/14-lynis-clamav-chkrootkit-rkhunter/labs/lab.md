# Lab — Host Audit + Malware/Rootkit + FIM
1. `examples/run-audits.sh` → Lynis hardening score, ClamAV, rkhunter, chkrootkit.
2. Drop the EICAR test string → ClamAV flags it.
3. Establish an AIDE baseline; change a file; `aide --check` detects it.
**Deliverable:** Lynis score, EICAR detection, AIDE change alert.
