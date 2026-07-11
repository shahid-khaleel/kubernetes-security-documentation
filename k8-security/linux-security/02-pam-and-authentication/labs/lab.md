# Lab — Account Lockout & Password Policy
1. Apply `examples/pam-faillock.conf` + `examples/pwquality.conf`.
2. Fail SSH login 5× → account locks (`faillock --user <u>`); unlock with `faillock --user <u> --reset`.
3. Try setting a weak password → rejected by pwquality.
**Deliverable:** lockout event + rejected weak password.
