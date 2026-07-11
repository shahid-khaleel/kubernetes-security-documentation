# 🧪 Lab Environment Bootstrap

**Read [`SAFETY.md`](SAFETY.md) first.** All attack demos run **only** in a disposable
VM / `kind` cluster you own.

## Recommended lab topology
```
   Your laptop / cloud VM (Ubuntu 22.04 or 24.04, 4 vCPU / 8 GB / 40 GB)
   ├── Docker Engine            → Docker + Linux labs
   ├── kind or minikube (K8s)   → Kubernetes labs
   └── (optional) 2nd throwaway VM for firewall / IR / forensics labs
```

## 1. Base tools (Ubuntu/Debian)
```bash
sudo apt-get update && sudo apt-get install -y \
  curl wget git jq vim tmux net-tools tcpdump auditd apparmor-utils \
  apparmor-profiles libpam-google-authenticator openssl ca-certificates uidmap
```

## 2. Docker Engine
```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"   # log out/in. NOTE: docker group == root (see Docker mod 06)
docker version
```

## 3. Kubernetes lab — `kind` (fastest) or `minikube`
```bash
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -m0755 kubectl /usr/local/bin/kubectl

# kind
curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
sudo install -m0755 kind /usr/local/bin/kind

# A cluster with audit logging + a worker node (used across K8s modules)
kind create cluster --name cks --config kind-cluster.yaml
kubectl get nodes
```
See [`kind-cluster.yaml`](kind-cluster.yaml) for a cluster preconfigured with an audit
policy mount and 1 control-plane + 2 workers.

## 4. Security tooling (installed per-module as needed)
| Tool | Purpose | Module |
|------|---------|--------|
| `trivy` | image/IaC/secret scanning | Docker 09 |
| `grype` / `syft` | CVE scan / SBOM | Docker 09, 14 |
| `cosign` | image signing | Docker 14, K8s 17 |
| `kube-bench` | CIS K8s benchmark | K8s 22 |
| `kube-hunter` | cluster pen-test | K8s 22 |
| `kubescape` | posture + NSA/MITRE | K8s 22 |
| `falco` | runtime detection | K8s 19 |
| `kyverno` / `gatekeeper` | admission policy | K8s 05 |
| `lynis` | Linux host audit | Linux 14, 16 |
| `velero` | backup/DR | K8s 24 |

Install helper: [`../scripts/install-security-tools.sh`](../scripts/install-security-tools.sh)

## 5. Tear down
```bash
kind delete cluster --name cks
docker system prune -af --volumes   # wipe lab containers/images
```
