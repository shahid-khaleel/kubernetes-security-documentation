# PCI DSS 4.0 -> Kubernetes control mapping (excerpt)
| PCI Req | Intent | K8s implementation | Module |
|---------|--------|--------------------|--------|
| 1.x | Network segmentation | NetworkPolicies default-deny, namespaces | 15,23 |
| 2.x | Secure config | CIS bench, PSA restricted, kube-bench | 06,21,22 |
| 3.x | Protect stored data | etcd encryption at rest, KMS | 13 |
| 4.x | Encrypt in transit | mTLS (Istio), TLS on ingress/API | 16,01 |
| 7.x | Least privilege | RBAC, SA scoping | 04,11 |
| 8.x | Identity/authN | OIDC, cert auth, MFA to platform | 03 |
| 10.x | Logging/monitoring | audit logs -> SIEM, Falco | 19,20 |
| 11.x | Testing | image scans, kube-hunter, pen tests | 09,22 |
