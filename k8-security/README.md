# 🛡️ Container & Linux Security Mastery

**Kubernetes Security · Docker Security · Linux Security — Beginner → Expert**

A complete, industry-grade, hands-on curriculum written from the perspective of a
Principal DevSecOps Engineer / CKS trainer. Every module follows the same rigorous
20-point structure (theory → architecture → attacks → detection → hardening →
compliance → labs → interview prep), and ships with runnable YAML, Dockerfiles,
shell scripts, and Kubernetes manifests.

> **Who this is for:** engineers targeting **CKS**, **CKA**, **Security+**, **CEH**,
> or a **DevSecOps / Cloud Security / Red Team** role, and teams hardening real
> banking, fintech, healthcare, and cloud-native platforms.

---

## 📁 Repository Layout

```
k8-security/
├── README.md                 ← you are here (start point)
├── CURRICULUM.md             ← full syllabus, every topic, learning path & timeline
├── _templates/
│   └── LESSON-TEMPLATE.md    ← the 20-point structure every lesson follows
├── resources/                ← cheatsheets, compliance mapping, tooling index, glossary
├── scripts/                  ← reusable hardening & audit scripts
├── labs/                     ← shared lab environment bootstrap (kind, minikube, VMs)
│
├── docker-security/          ← Track 1 — 15 modules
│   ├── README.md
│   └── NN-topic/
│       ├── README.md         ← the lesson (20-point format)
│       ├── examples/         ← Dockerfiles, YAML, configs
│       └── labs/             ← step-by-step hands-on + attack/defense
│
├── linux-security/           ← Track 2 — 17 modules
│   └── NN-topic/ …
│
├── kubernetes-security/      ← Track 3 — 26 modules
│   └── NN-topic/ …
│
└── kubernetes-concepts/      ← Track 4 — official-docs-aligned, 61 topics (security lens)
    └── NN-section/NN-topic/  ← Security · Policies · Scheduling · Cluster Admin ·
                                 Observability · Windows · Extending Kubernetes
```

---

## 🎯 How to Use This Curriculum

1. **Read [`CURRICULUM.md`](CURRICULUM.md)** for the full topic map and recommended order.
2. **Build the lab first** — [`labs/README.md`](labs/README.md) bootstraps everything you
   need (a throwaway Linux VM, Docker, and a `kind`/`minikube` cluster). *Never run
   attack demos on shared or production systems.*
3. **Work bottom-up:** Linux → Docker → Kubernetes. Container security *is* Linux
   security (namespaces, cgroups, capabilities, seccomp, LSMs). If you skip the Linux
   layer, Kubernetes security becomes memorization instead of understanding.
4. **Do every lab.** Each module has an attack demo *and* the detection + prevention
   for it. Security is a muscle — read less, break/fix more.
5. **Use the [`resources/`](resources/) cheatsheets** during hands-on and interviews.

### The recommended learning order (dependency-aware)

```
        LINUX SECURITY (the foundation)
        permissions → PAM/SSH/sudo → LSM (SELinux/AppArmor)
        → kernel hardening → firewalls → auditd → PKI/TLS → IR/forensics
                              │
                              ▼
        DOCKER SECURITY (Linux primitives, applied)
        architecture → namespaces → cgroups → runtimes → rootless
        → daemon/socket → Dockerfile → distroless → scanning
        → runtime hardening → supply chain → IR
                              │
                              ▼
        KUBERNETES SECURITY (orchestration on top)
        control plane → nodes → authN → authZ/RBAC → admission
        → PSA/SecurityContext → seccomp/LSM/caps → SA/secrets/encryption
        → network policy/mTLS → image/supply-chain → runtime (Falco/eBPF)
        → audit → CIS/NSA hardening → multi-tenancy → DR → compliance → IR
```

---

## 📚 The Three Tracks at a Glance

| Track | Modules | Focus | Key certs |
|-------|:------:|-------|-----------|
| **[Linux Security](linux-security/)** | 17 | The kernel & OS primitives all containers rely on | CIS Linux, RHCSA-Sec, Security+ |
| **[Docker Security](docker-security/)** | 15 | Building, running & shipping containers safely | Docker DCA, Security+ |
| **[Kubernetes Security](kubernetes-security/)** | 26 | Securing the orchestrator end-to-end | **CKS**, CKA |
| **[Kubernetes Concepts & Hardening](kubernetes-concepts/)** | 61 | Official-docs concept tree (Security, Policies, Scheduling, Cluster Admin, Observability, Windows, Extending) through a security lens | **CKS/CKA** |

---

## 🧩 The 20-Point Lesson Format

Every module `README.md` answers these, in order (see
[`_templates/LESSON-TEMPLATE.md`](_templates/LESSON-TEMPLATE.md)):

1. What it is · 2. Why it exists · 3. Problem it solves · 4. How it works internally ·
5. Architecture (diagrams) · 6. Security risks · 7. Common attacks · 8. Production
use-cases · 9. Best practices · 10. Hardening · 11. Compliance (CIS/PCI/ISO/SOC2/GDPR/
HIPAA/NIST) · 12. Performance · 13. Troubleshooting · 14. Monitoring & auditing ·
15. Logging · 16. DR & backup · 17. Interview questions · 18. Common mistakes ·
19. Advanced concepts · 20. Production examples (banking/fintech/healthcare/cloud-native).

Each also closes with: **Summary · Hands-on Lab · Troubleshooting Exercise · Quiz ·
Interview Questions (3 levels) · Production Scenario · Assignment / Mini-project.**

---

## 🏆 Capstone Projects (cross-track)

Located in [`CURRICULUM.md`](CURRICULUM.md#-capstone-projects). Highlights:

- **CAP-1 — "Zero-Trust Bank Cluster":** a CIS-benchmarked, multi-tenant EKS-style
  cluster with mTLS, signed images, admission policy, Falco, and encrypted secrets.
- **CAP-2 — "Breach & Contain":** deploy a deliberately vulnerable app, attack it
  (container escape → lateral movement), then detect, contain, and do forensic RCA.
- **CAP-3 — "Compliance-in-a-Box":** map one platform to CIS + PCI-DSS + SOC 2 with
  automated evidence collection (kube-bench, Lynis, OpenSCAP, Trivy).

---

## ⚠️ Safety & Ethics

All attack demonstrations are for **authorized, defensive, educational** use in an
**isolated lab you own**. Run them in disposable VMs / `kind` clusters — never against
systems you don't have written permission to test. See
[`labs/SAFETY.md`](labs/SAFETY.md).

---

## ✅ Progress Tracker

- [ ] Linux Security (17)
- [ ] Docker Security (15)
- [ ] Kubernetes Security (26)
- [ ] Capstone 1 — Zero-Trust Bank Cluster
- [ ] Capstone 2 — Breach & Contain
- [ ] Capstone 3 — Compliance-in-a-Box

> **Start here →** [`CURRICULUM.md`](CURRICULUM.md), then [`labs/README.md`](labs/README.md).
