# Lab — Kernel Hardening
1. Apply `examples/99-hardening.conf` (`sysctl --system`).
2. Verify: `sysctl kernel.randomize_va_space kernel.kptr_restrict kernel.yama.ptrace_scope`.
3. Test ptrace_scope: try to `strace` another user's process → denied.
**Deliverable:** sysctl values + the blocked ptrace.
