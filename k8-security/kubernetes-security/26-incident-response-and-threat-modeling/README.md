# 26 — Incident Response & Threat Modeling

> **Track:** Kubernetes Security · **Level:** ⚫ · **Refs:** NIST IR-4/800-61, MITRE ATT&CK for Containers, STRIDE

**Objectives:** run the IR lifecycle for K8s; contain compromised pods/nodes without losing evidence; threat-model with STRIDE/ATT&CK.

## 1–5. Concept
The capstone. **Threat modeling** (proactive) uses **STRIDE** and the **4 C's** to find weaknesses
before attackers do; **MITRE ATT&CK for Containers** catalogs real techniques (initial access →
execution → privilege escalation → escape → lateral movement → exfil). **IR** (reactive) follows
**Detect → Triage → Contain → Eradicate → Recover → Lessons Learned** (NIST 800-61), adapted to
K8s: contain by **cordon + NetworkPolicy isolation + label**, preserve evidence (don't just
delete pods), rotate exposed SA tokens/secrets, redeploy from signed images.

## 6–7. Risks & attack chains
- Compromised pod → SA token theft → RBAC pivot → privileged/hostPath pod → node escape →
  cluster-wide lateral movement → etcd/secret exfil or ransomware. Each link maps to a control
  in this track — IR is where they're tested.

## 9–10. Best practices & procedures
- **Playbook**: [examples/ir-playbook-compromised-pod.md](examples/ir-playbook-compromised-pod.md). **Isolate**:
  [examples/isolate-networkpolicy.yaml](examples/isolate-networkpolicy.yaml) (zero ingress/egress) + `kubectl cordon`.
- Detect with Falco+audit (19/20); **preserve** pod/node evidence before eradication; rotate all
  reachable secrets; rebuild from golden/signed images; write an ATT&CK-mapped RCA; feed fixes back
  into admission/Falco/threat model. Prepare + drill *before* the incident.

## 11. Compliance
| NIST IR-4/5/6 | PCI 12.10 | ISO A.5.24-27 | HIPAA 164.308(a)(6) | GDPR Art.33/34 |
|---|---|---|---|---|
| IR handling | IR plan/test | incident mgmt | response | 72h breach notice |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) — the **Breach & Contain** mini-capstone. **Quiz:** IR phases? Why isolate not delete? What is STRIDE? Name three ATT&CK-for-Containers tactics. **Interview —** *B:* First step when a pod is compromised? *I:* Contain a compromised pod, preserving evidence. *A:* Run a full cluster-compromise IR + threat-model the platform. **Scenario:** Falco flags escape attempt from a pod → follow the playbook: isolate + cordon, collect evidence, trace the ATT&CK chain, rotate secrets, rebuild, RCA, harden the gaps (this is Capstone 2).
