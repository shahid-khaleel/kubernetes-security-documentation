# Application Security Checklist (Workload/Developer)

Developer-facing checklist for shipping a secure workload (the "Code" + "Container" C's).

## Container image
- [ ] Minimal/distroless base, pinned by **digest**; multi-stage build → [docker/07](../../../docker-security/07-dockerfile-best-practices/),[08](../../../docker-security/08-multistage-and-distroless/)
- [ ] Scanned (HIGH/CRIT fixable = fail CI); **signed** (cosign) → [docker/09](../../../docker-security/09-image-scanning-trivy-grype-scout-snyk/),[14](../../../docker-security/14-supply-chain-sbom-cosign-notary/)
- [ ] No secrets in layers/env (use BuildKit `--secret`) → [docker/10](../../../docker-security/10-secrets-management/)
## Pod spec
- [ ] `runAsNonRoot`, numeric `runAsUser`, `readOnlyRootFilesystem: true`
- [ ] `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`, `seccompProfile: RuntimeDefault`
- [ ] `resources.requests/limits` set (cpu/mem) + no `privileged`/hostPath/host namespaces
- [ ] Dedicated ServiceAccount; `automountServiceAccountToken` only if the API is used
## Data & config
- [ ] Secrets mounted as files (not env); pulled from Vault/CSI where possible
- [ ] TLS for all external calls; validate certs; no hardcoded creds → [Linux/15](../../../linux-security/15-tls-pki-openssl-certificates/)
## Network
- [ ] NetworkPolicy for the workload (ingress + egress allowlist incl. DNS)
- [ ] Liveness/readiness probes; graceful shutdown; PodDisruptionBudget
## Code
- [ ] Dependency scanning (SCA) + SAST in CI; input validation; SBOM generated
- [ ] No debug endpoints/verbose errors in prod; rate limiting

**Golden pod template:** [../../../kubernetes-security/06-pod-security-admission/examples/restricted-compliant-pod.yaml](../../../kubernetes-security/06-pod-security-admission/examples/restricted-compliant-pod.yaml)
