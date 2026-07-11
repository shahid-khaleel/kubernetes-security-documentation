# Lab — Confine an App with AppArmor
1. Load `examples/usr.sbin.myapp.profile` (`apparmor_parser -r`).
2. `aa-status` shows enforce; the app cannot read /etc/shadow or write /bin.
3. Use complain mode + `aa-logprof` to generate a profile from real behavior.
**Deliverable:** enforced profile + a denied access in the logs.
