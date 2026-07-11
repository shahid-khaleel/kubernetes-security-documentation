# Lab — Service Account Token Hygiene
1. Default pod: exec in, `cat /var/run/secrets/kubernetes.io/serviceaccount/token` exists.
2. Apply `examples/sa-no-automount-and-bound-token.yaml`; confirm token no longer auto-mounted,
   and the projected token is short-lived/audience-bound (decode exp + aud claims).
**Deliverable:** show automount disabled + bound-token claims.
