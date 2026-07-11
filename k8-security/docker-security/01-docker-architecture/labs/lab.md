# Lab — Map the Docker Stack
1. Run `examples/inspect-architecture.sh`.
2. Identify each process: `dockerd` (API), `containerd` (lifecycle), `containerd-shim`
   (per-container parent), `runc` (creates then exits). Draw the tree.
3. Kill `dockerd` and note containers keep running (shim owns them) — that's `live-restore`.
**Deliverable:** annotated process tree client→dockerd→containerd→shim→runc.
