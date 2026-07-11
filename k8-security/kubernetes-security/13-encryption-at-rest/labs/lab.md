# Lab — Encryption at Rest
1. Apply an EncryptionConfiguration (aescbc or KMS from examples/), restart apiserver.
2. Re-encrypt existing: `kubectl get secrets -A -o json | kubectl replace -f -`.
3. Run `examples/verify-encryption.sh` → etcd shows `k8s:enc:` not plaintext.
4. Rotate the key (add key2 first, re-encrypt, then remove key1).
**Deliverable:** hexdump proving ciphertext + a documented rotation.
