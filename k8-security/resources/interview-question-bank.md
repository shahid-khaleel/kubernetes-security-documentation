# 🎤 Master Interview Question Bank (Container & Linux Security)

## Beginner
1. Difference between a container and a VM — and the security implication of a shared kernel?
2. What does `runAsNonRoot: true` do, and why isn't `USER` in the Dockerfile enough on its own?
3. What is RBAC in Kubernetes? Role vs ClusterRole?
4. Why is `docker run --privileged` dangerous?
5. Is a Kubernetes Secret encrypted by default? (No — base64; needs encryption at rest.)
6. What are the three special permission bits in Linux and what does each do?
7. What is a NetworkPolicy and what happens with none defined? (Allow-all.)
8. Why disable password auth for SSH?

## Intermediate
1. Walk through what happens when a pod is created — through authN, authZ, admission, scheduling.
2. How do namespaces + cgroups + capabilities + seccomp combine to isolate a container?
3. How would you prevent pods from running as root cluster-wide? (PSA restricted / admission policy.)
4. Explain the docker.sock escape and how to prevent it.
5. Difference between SELinux and AppArmor; when would you pick each?
6. How does mutual TLS establish workload identity in a mesh?
7. How do you scope a ServiceAccount so a compromised pod can't call the whole API?
8. What's the difference between seccomp `RuntimeDefault` and a custom profile?

## Advanced / CKS-grade
1. Design defense-in-depth for a multi-tenant cluster processing card data (map to the 4 C's).
2. A pod was compromised — walk the full IR: detect → contain → eradicate → recover → RCA, mapping to MITRE ATT&CK for Containers.
3. How do you achieve supply-chain integrity end-to-end (SBOM + signing + SLSA + admission verification)?
4. How does user-namespace remapping change the impact of a container escape?
5. Explain envelope encryption for etcd (KMS v2) and how key rotation works without downtime.
6. How would you detect and block a container that spawns a reverse shell in real time?
7. Threat-model the Kubernetes control plane using STRIDE.
8. How do you prove PCI-DSS + CIS compliance continuously (evidence automation) for a fleet?
