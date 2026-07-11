#!/usr/bin/env bash
# POSIX ACL: shared team dir where 'devs' get rwx and new files inherit it (default ACL).
set -euo pipefail
sudo mkdir -p /srv/team
sudo chgrp devs /srv/team
sudo chmod 2770 /srv/team                      # SGID so new files inherit group 'devs'
sudo setfacl -m g:devs:rwx /srv/team           # access ACL
sudo setfacl -d -m g:devs:rwx /srv/team        # DEFAULT ACL -> applies to new children
getfacl /srv/team
