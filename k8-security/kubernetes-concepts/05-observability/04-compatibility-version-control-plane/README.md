# Compatibility Version for Control Plane Components

**What it is.** The **emulated compatibility version** feature lets control-plane components
run newer binaries while **emulating an older API version's behavior** (`--emulated-version`),
decoupling binary upgrade from behavioral/feature-gate changes for safer, staged upgrades.

**Why it matters (security).** **Timely patching** is a core control, but teams delay upgrades
fearing behavior changes. Compatibility versioning lets you **apply security patches (new
binary) without immediately adopting risky new behaviors** — removing an excuse to run
unpatched control planes. It also enables safer rollback.

**Best practices**
- Use it to **decouple security patching from feature adoption**; patch promptly, adopt new
  behavior deliberately.
- Keep skew within supported bounds; test emulated version in staging; don't run EOL versions.
**Cross-links:** [control-plane security](../../../kubernetes-security/01-control-plane-security/), [CIS/NSA hardening](../../../kubernetes-security/21-cluster-hardening-cis-nsa/).
