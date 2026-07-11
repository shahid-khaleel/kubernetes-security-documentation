# Lab — Breach & Contain (mini)
1. Deploy a deliberately weak pod (mounted docker.sock or privileged).
2. ATTACK: escalate / escape (document each ATT&CK technique used).
3. DETECT via Falco + audit logs; CONTAIN with `examples/isolate-networkpolicy.yaml` + cordon.
4. Follow `examples/ir-playbook-compromised-pod.md`; write the RCA.
**Deliverable:** an IR report mapping actions to MITRE ATT&CK for Containers.
