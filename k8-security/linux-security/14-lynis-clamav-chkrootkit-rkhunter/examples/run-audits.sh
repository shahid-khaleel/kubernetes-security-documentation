#!/usr/bin/env bash
# Host security audit + malware/rootkit + FIM.
set -euo pipefail
sudo lynis audit system --quiet            # hardening score + suggestions
sudo freshclam && sudo clamscan -r --infected /home /tmp /var/tmp
sudo rkhunter --update && sudo rkhunter --check --sk
sudo chkrootkit
# FIM baseline (AIDE): sudo aideinit && sudo aide --check
