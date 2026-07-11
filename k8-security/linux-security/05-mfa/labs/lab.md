# Lab — TOTP MFA for SSH
1. Follow `examples/sshd-mfa-totp.md`; enroll with `google-authenticator`.
2. Log in → prompted for key AND 6-digit OTP.
3. Test lockout-safety: keep a session open; verify a bad OTP is rejected.
**Deliverable:** an SSH login requiring publickey + OTP.
