#!/usr/bin/env bash
# Stand up a tiny internal CA and issue a server cert (mTLS building block).
set -euo pipefail
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/CN=Corp Root CA"
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=app.corp.local"
cat > san.ext <<X
subjectAltName=DNS:app.corp.local
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
X
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt -days 365 -sha256 -extfile san.ext
openssl x509 -in server.crt -noout -text | grep -A1 'Subject Alternative Name'
