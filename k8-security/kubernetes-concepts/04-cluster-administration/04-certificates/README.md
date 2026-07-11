# Certificates

**What it is.** Kubernetes is **TLS everywhere** — the control plane runs an internal **PKI**
(cluster CA in `/etc/kubernetes/pki`) issuing certs for apiserver, etcd, kubelet, controllers,
and users. The **CertificateSigningRequest (CSR)** API lets clients request signed certs;
kubelet certs auto-rotate.

**Why it matters (security).** These certs are **identities and trust anchors**. A stolen CA
key = impersonate anything (game over). Expired certs = cluster outage. Weak/again long-lived
client certs can't be revoked (no CRL).

**Example — approve a CSR (concept):** [examples/csr.yaml](examples/csr.yaml)
**Best practices**
- Protect the **cluster CA key** (offline/HSM where possible); short-lived certs; enable
  **kubelet cert rotation** (`rotateCertificates: true`).
- **Monitor expiry** (`kubeadm certs check-expiration`); automate renewal — expired control-
  plane certs are a classic outage.
- Use cert-manager for workload/ingress TLS; don't reuse the cluster CA for app TLS.
- Client certs for break-glass only (no revocation) — prefer OIDC ([sec/03](../../../kubernetes-security/03-authentication/)).
**Cross-links:** [control-plane security](../../../kubernetes-security/01-control-plane-security/), [Linux/15 — PKI/TLS](../../../linux-security/15-tls-pki-openssl-certificates/).
