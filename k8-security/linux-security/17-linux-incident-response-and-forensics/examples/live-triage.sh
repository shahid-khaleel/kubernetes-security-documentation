#!/usr/bin/env bash
# Live-response triage collector (run as root; write to EXTERNAL/read-only media).
set -euo pipefail
OUT="ir-$(hostname)-$(date +%F-%H%M)"; mkdir -p "$OUT"; cd "$OUT"
date -u > collection-time.txt
uname -a > uname.txt; uptime > uptime.txt
ps auxww > processes.txt
ss -tulpnae > sockets.txt                    # listening + established w/ pids
lsof -n > openfiles.txt 2>/dev/null || true
who -a > who.txt; last -F > last.txt
cp /var/log/auth.log* . 2>/dev/null || true
find / -xdev -newermt '-1 day' -type f 2>/dev/null > recently-modified.txt
find / -xdev -perm -4000 -type f 2>/dev/null > suid.txt      # planted SUID?
crontab -l > root-cron.txt 2>/dev/null || true
ls -la /etc/cron.* /etc/systemd/system > persistence.txt 2>/dev/null || true
echo "Collected to $OUT — next: image disk (dd/dc3dd) & memory (avml/LiME) before powering off."
