#!/usr/bin/env bash
# permission-audit.sh — Linux DAC/SUID/world-writable posture auditor.
# Referenced by linux-security/01. Read-only; safe to run. Outputs findings + a baseline.
# Usage: sudo ./permission-audit.sh [--baseline FILE] [--json]
set -euo pipefail

JSON=0; BASELINE=""
while [[ $# -gt 0 ]]; do case "$1" in
  --json) JSON=1; shift;;
  --baseline) BASELINE="$2"; shift 2;;
  *) echo "unknown arg: $1"; exit 2;;
esac; done

hr(){ printf '%s\n' "----------------------------------------------------------------"; }
note(){ printf '[*] %s\n' "$*"; }

note "SUID/SGID binaries (baseline these; alert on new ones):"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -printf '%m %u %g %p\n' 2>/dev/null | sort

hr
note "World-writable FILES (should be ~none):"
find / -xdev -type f -perm -0002 2>/dev/null | sort

hr
note "World-writable DIRECTORIES missing the sticky bit (fix with chmod +t):"
find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null | sort

hr
note "Files with NO valid owner or group (orphaned):"
find / -xdev \( -nouser -o -nogroup \) 2>/dev/null | sort

hr
note "Sensitive file modes:"
for f in /etc/passwd /etc/shadow /etc/gshadow /etc/group /etc/sudoers; do
  [ -e "$f" ] && stat -c '%a %U:%G %n' "$f"
done

hr
note "Files with capabilities (SUID alternative — review each):"
getcap -r / 2>/dev/null | sort || true

# Baseline / drift detection
if [[ -n "$BASELINE" ]]; then
  CUR="$(mktemp)"
  find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null | sort > "$CUR"
  if [[ -f "$BASELINE" ]]; then
    hr; note "Drift vs baseline $BASELINE (lines with > are NEW/removed):"
    diff "$BASELINE" "$CUR" && note "No SUID/SGID drift." || true
  else
    cp "$CUR" "$BASELINE"; note "Baseline written to $BASELINE"
  fi
  rm -f "$CUR"
fi
