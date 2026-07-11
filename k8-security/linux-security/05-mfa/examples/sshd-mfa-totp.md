# TOTP MFA for SSH (Google Authenticator PAM)
1. apt-get install -y libpam-google-authenticator && run `google-authenticator` per user
2. /etc/pam.d/sshd  -> add:  auth required pam_google_authenticator.so
3. /etc/ssh/sshd_config ->  KbdInteractiveAuthentication yes
   AuthenticationMethods publickey,keyboard-interactive   # key + OTP (true 2FA)
4. systemctl restart sshd  (keep a second session open to avoid lockout!)
