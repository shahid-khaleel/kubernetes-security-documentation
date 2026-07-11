# Lab — Build a CA + Issue Certs
1. `examples/make-ca-and-cert.sh` → root CA + SAN server cert.
2. Serve with `openssl s_server`; connect with `openssl s_client -CAfile ca.crt` → verified.
3. Inspect/verify chain + expiry; simulate expiry handling.
**Deliverable:** a verified TLS handshake against your own CA.
