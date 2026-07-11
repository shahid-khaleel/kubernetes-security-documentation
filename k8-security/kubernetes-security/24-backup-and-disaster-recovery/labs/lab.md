# Lab — Backup & Restore
1. etcd snapshot with `examples/etcd-snapshot.sh`; verify with `etcdctl snapshot status`.
2. Install Velero, apply `examples/velero-schedule.yaml`, run an on-demand backup.
3. DR drill: delete a namespace, then `velero restore create --from-backup ...`.
**Deliverable:** successful restore + measured RTO.
