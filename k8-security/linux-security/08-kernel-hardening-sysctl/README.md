# 08 — Kernel Hardening (sysctl & more)

> **Track:** Linux Security · **Level:** 🔴 · **Refs:** CIS 3.x, NIST SC-39/SI-16

**Objectives:** apply hardening sysctls (ASLR, ptrace, kptr, network); understand module signing & kernel lockdown.

## Concept
The kernel is the ultimate trust boundary (especially for containers — shared kernel). Runtime
tunables via **`sysctl`** (persist in `/etc/sysctl.d/`) plus build/boot features (module
signing, **lockdown** LSM, KASLR) reduce exploitability and blast radius. Key knobs: full
**ASLR** (`randomize_va_space=2`), **`kptr_restrict`/`dmesg_restrict`** (hide kernel info),
**`yama.ptrace_scope`** (block process injection), **`unprivileged_bpf_disabled`**,
**`fs.protected_symlinks/hardlinks`** (stop link races), and network anti-spoofing (`rp_filter`,
disable redirects/source-route, `tcp_syncookies`).

## Risks & attacks
- Kernel LPEs (privesc) — hardening raises the bar (info leaks blocked, injection restricted).
- ptrace injection into other processes (T1055). Symlink/hardlink race attacks in shared dirs.
- IP spoofing / redirect attacks without network sysctls. Unsigned module loading = rootkits.

## Best practices & hardening
- Apply [examples/99-hardening.conf](examples/99-hardening.conf) (`sysctl --system`); verify values.
- Enable module signature enforcement + kernel `lockdown=confidentiality`; disable `kexec`.
- Keep kernels patched (livepatch for uptime-critical). Disable unused protocols/modules.

## Compliance
| CIS 3.x | PCI 2.2 | ISO A.8.9 | NIST SC-39/SI-16 | STIG |
|---|---|---|---|---|
| kernel/net params | secure config | config mgmt | isolation/memprot | sysctl hardening |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md). **Quiz:** What does `randomize_va_space=2` do? Purpose of `ptrace_scope=1`? Why disable redirects? **Interview —** *B:* What is ASLR? *I:* Which sysctls harden a container host and why? *A:* Defense-in-depth for kernel-exploit container escapes. **Scenario:** shared-kernel container host → apply sysctl baseline, restrict bpf/ptrace, sign modules, patch cadence, verify with Lynis.
