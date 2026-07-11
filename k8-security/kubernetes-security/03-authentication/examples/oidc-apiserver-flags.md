# OIDC auth for kube-apiserver (enterprise SSO — Okta/Azure AD/Keycloak)
--oidc-issuer-url=https://login.example.com/
--oidc-client-id=kubernetes
--oidc-username-claim=email
--oidc-groups-claim=groups
--oidc-username-prefix="oidc:"
--oidc-groups-prefix="oidc:"

# Map the OIDC groups to RBAC (module 04) via a ClusterRoleBinding to the group name.
