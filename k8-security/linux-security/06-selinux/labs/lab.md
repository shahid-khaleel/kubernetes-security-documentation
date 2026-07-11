# Lab — SELinux Enforcing
1. `getenforce`; ensure Enforcing. Serve a file from a wrong-context dir → denied.
2. Fix via `semanage fcontext` + `restorecon` (NOT by disabling SELinux).
3. Turn an AVC into a module with `audit2allow` (review before installing).
**Deliverable:** an AVC denial + the correct labeling fix.
