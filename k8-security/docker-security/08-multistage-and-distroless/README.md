# 08 — Multi-stage Builds & Distroless Images

> **Track:** Docker Security · **Level:** 🟡 · **Refs:** CIS Docker 4.x, NIST 800-190

**Objectives:** shrink attack surface with multi-stage builds, distroless/scratch/chainguard bases.

## Concept
**Multi-stage builds** compile in a fat "build" stage and copy only the artifact into a
minimal "runtime" stage — no compilers/package managers/shells in the final image.
**Distroless** (Google), **scratch** (empty), and **Chainguard/Wolfi** images contain only
your app + runtime deps: fewer packages = **fewer CVEs and fewer escape tools** (no shell for
an attacker to use).

## Risks it reduces
- Large bases (`ubuntu`, `node`) carry hundreds of packages → large CVE surface + shells,
  package managers, and debug tools an attacker can leverage after RCE.

## Best practices & hardening
- Multi-stage + smallest viable base; `-nonroot` distroless variants; static binaries in
  `scratch` (Go/Rust). Examples: [examples/Dockerfile.go-scratch](examples/Dockerfile.go-scratch),
  plus the Node distroless in module 07's [Dockerfile.hardened](../07-dockerfile-best-practices/examples/Dockerfile.hardened).
- No shell means debug via ephemeral/debug containers, not baking tools into prod images.

## Compliance
| CIS Docker 4.x | PCI 6.x/11.x | ISO A.8.8 | NIST SI-2 |
|---|---|---|---|
| minimal images | vuln reduction | vuln mgmt | flaw remediation |

## Lab / quiz / interview / scenario
Lab: [labs/lab.md](labs/lab.md) — compare size + CVE count. **Quiz:** Why distroless? What's in `scratch`? Debug a shell-less image how? **Interview —** *B:* What is a multi-stage build? *I:* Convert an image to distroless. *A:* Trade-offs of scratch/distroless for observability. **Scenario:** image has 300 CVEs mostly from the base → move to distroless-nonroot, re-scan, confirm CVE drop + non-root.
