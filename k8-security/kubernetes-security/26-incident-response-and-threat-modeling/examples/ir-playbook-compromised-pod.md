# IR Playbook — Compromised Pod (MITRE ATT&CK for Containers)
## 1. Detect (Falco/audit): shell in container, unexpected egress, cap abuse
## 2. Triage: identify pod, node, image, serviceaccount, namespace
kubectl get pod <p> -n <ns> -o yaml
## 3. CONTAIN (do NOT delete — preserve evidence):
kubectl label pod <p> -n <ns> quarantine=true
kubectl cordon <node>                                     # stop new scheduling
kubectl apply -f isolate-networkpolicy.yaml               # cut pod egress/ingress
## 4. COLLECT: kubectl cp process list, /proc, logs; snapshot node disk & memory
## 5. ERADICATE: rotate the SA token + any exposed secrets; rebuild image; patch entry vector
## 6. RECOVER: redeploy from signed image; verify with kube-bench
## 7. LESSONS: map to ATT&CK, update admission/Falco rules, threat model (STRIDE)
