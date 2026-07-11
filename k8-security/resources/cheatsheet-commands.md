# ⚡ Command Cheatsheet

## Linux
```bash
find / -perm -4000 -type f 2>/dev/null           # SUID binaries
getcap -r / 2>/dev/null                            # file capabilities
getfacl FILE ; setfacl -m u:bob:rw FILE            # ACLs
ausearch -k identity ; aureport --summary          # audit trail
sshd -t                                            # validate sshd config
sysctl -a | grep randomize_va_space                # ASLR status
getenforce ; aa-status                             # SELinux / AppArmor state
```
## Docker
```bash
docker run --cap-drop=ALL --security-opt=no-new-privileges \
  --read-only --user 10001 --pids-limit=200 IMAGE   # hardened run
docker history --no-trunc IMG | grep -i secret       # leaked build secrets?
docker inspect C | jq '.[0].HostConfig.SecurityOpt'  # applied security opts
docker diff C                                        # fs changes (IR)
trivy image --severity HIGH,CRITICAL IMG             # scan
```
## Kubernetes
```bash
kubectl auth can-i --list --as system:serviceaccount:ns:sa   # what can this SA do?
kubectl get clusterrolebindings -o wide | grep cluster-admin # over-privilege
kubectl get netpol -A                                        # policies present?
kubectl get ns -L pod-security.kubernetes.io/enforce         # PSA levels
kubectl create token SA | cut -d. -f2 | base64 -d | jq       # decode SA JWT
kubectl get --raw /api/v1/namespaces/NS/secrets/S            # (needs RBAC)
```
