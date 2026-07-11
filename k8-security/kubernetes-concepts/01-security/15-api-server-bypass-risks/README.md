# Kubernetes API Server Bypass Risks

**What it is.** Ways to affect the cluster **without going through the API server** — thereby
**bypassing RBAC, admission, and audit logging**. If you only secure the API, these are blind
spots.

**Why it matters.** These paths defeat your central controls; they're prime escalation and
evasion techniques (and common CKS/interview material).

**The bypass paths & mitigations**
| Bypass | Risk | Mitigation |
|---|---|---|
| **Kubelet API** (`:10250`) | exec/read pods directly | anonymous-auth off, authZ Webhook, `readOnlyPort=0` ([sec/02](../../../kubernetes-security/02-node-security/)) |
| **etcd** direct access | read/write ALL state incl. secrets | mTLS + peer certs, restrict to control plane, encrypt ([sec/01](../../../kubernetes-security/01-control-plane-security/),[13](../../../kubernetes-security/13-encryption-at-rest/)) |
| **Static pods** (kubelet manifests dir) | run pods with no API/admission check | restrict node/file access; monitor `/etc/kubernetes/manifests` |
| **Container runtime / `docker.sock`** on node | create privileged containers | node access control; never mount runtime socket in pods |
| **Cloud metadata endpoint** (169.254.169.254) | steal node IAM creds → cloud takeover | NetworkPolicy/hop-limit block; IMDSv2; least-priv node role |
| **Node SSH / host access** | full node = all pod secrets | bastion+MFA, PAM, no shared node access |

**Best practices:** treat node/host access as privileged; audit these paths; runtime detection
(Falco, [sec/19](../../../kubernetes-security/19-runtime-security-falco-ebpf/)) catches what audit logs miss.
