# 06 — SELinux

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS 1.6, NIST AC-3/SC-7, STIG

**Objectives:** understand MAC vs DAC; read type/context labels; fix denials the right way (labels/booleans, not disabling); write policy with audit2allow.

## 1–5. What / why / how / architecture
**SELinux** is a **Mandatory Access Control (MAC)** LSM: a central, kernel-enforced policy
that constrains what every process (subject) may do to every object — **overriding DAC and
even root**. It uses **type enforcement**: everything gets a context
`user:role:type:level` (e.g. `httpd_t` process, `httpd_sys_content_t` file); policy allows
only explicitly-permitted type interactions. Modes: **Enforcing** (block+log), **Permissive**
(log only), **Disabled**. **Targeted** policy (default) confines high-risk daemons; **MLS/strict**
confines everything. **Booleans** toggle common policy choices without recompiling.
```
 process (httpd_t) ──wants──► file (user_home_t)   POLICY: not allowed ⇒ AVC denial (blocked)
 DAC says yes ──▶ SELinux still says NO  (MAC overrides DAC; root is not exempt)
```

## 6–7. Risks & attacks
- The #1 *mistake*: `setenforce 0` / `SELINUX=disabled` to "fix" an app → removes a whole
  defense layer (and containers on RHEL rely on SELinux for isolation).
- Mislabeling → either breakage or over-permissive custom modules. Overly broad `audit2allow`
  modules can grant more than intended. Confined-process escapes still limited by type.

## 9–10. Best practices & hardening
- **Stay Enforcing.** Fix denials by **relabeling** (`restorecon`, `semanage fcontext`) or
  **booleans** (`setsebool -P`), not by disabling. Review AVCs (`ausearch -m avc`).
- Turn recurring AVCs into vetted modules with `audit2allow` — **read before installing**.
- Use unique **MCS categories** to isolate containers/tenants. Commands: [examples/selinux-commands.sh](examples/selinux-commands.sh).

## 11. Compliance
| CIS 1.6 | PCI 2.2 | ISO A.8.22 | NIST AC-3/SC-39 | STIG (RHEL) |
|---|---|---|---|---|
| enable/enforce | secure config | segregation | mandatory access | SELinux enforcing |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** MAC vs DAC? What is a type/context? Enforcing vs Permissive? Why not disable to fix a denial? **Interview —** *B:* What does SELinux do that chmod can't? *I:* Walk through fixing a web-server AVC correctly. *A:* Explain SELinux's role in container isolation + MCS. **Scenario:** app broke after deploy, team wants SELinux off → find the AVC, relabel/boolean it, keep enforcing, document.
