# Lab — STRICT mTLS with Istio
1. `istioctl install --set profile=demo`; label ns `istio-injection=enabled`; deploy 2 apps.
2. Apply `examples/peerauthentication-strict.yaml`; a non-mesh client gets connection reset.
3. Apply `examples/authorizationpolicy-least-privilege.yaml`; only the frontend SA can call /api.
4. Verify certs: `istioctl proxy-config secret <pod>`.
**Deliverable:** show plaintext rejected + authZ enforced by SA identity.
