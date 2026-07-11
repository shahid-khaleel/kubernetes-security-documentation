# Dangerous Linux capabilities to NEVER grant in multi-tenant clusters
| Capability | Why it's dangerous |
|------------|--------------------|
| SYS_ADMIN | "the new root" — mount, namespaces, many escapes |
| SYS_PTRACE | inspect/inject other processes |
| SYS_MODULE | load kernel modules -> full host compromise |
| NET_ADMIN | reconfigure host networking |
| NET_RAW | craft packets, ARP/DNS spoofing |
| DAC_OVERRIDE / DAC_READ_SEARCH | bypass file permission checks |
| SYS_BOOT / SYS_TIME | reboot / change clock (log tampering) |
Detect: `kubectl get pods -A -o json | jq '..|.capabilities?|.add?|select(.)'`
