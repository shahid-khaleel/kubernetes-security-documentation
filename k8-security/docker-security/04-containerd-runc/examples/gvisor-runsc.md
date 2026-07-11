# Stronger isolation runtimes (defense against kernel-exploit container escapes)
## gVisor (runsc) — user-space kernel intercepts syscalls
/etc/docker/daemon.json:
  { "runtimes": { "runsc": { "path": "/usr/local/bin/runsc" } } }
Run:  docker run --runtime=runsc alpine uname -a
## Kata Containers — lightweight VM per container (hardware isolation)
docker run --runtime=kata-runtime ...
## When to use: multi-tenant / untrusted workloads where a shared kernel is unacceptable.
## CVE-2019-5736: runc host-binary overwrite escape — patch runc, use read-only + userns.
