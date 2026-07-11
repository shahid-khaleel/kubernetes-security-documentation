# Swap Memory Management

**What it is.** Kubernetes support for **swap** on Linux nodes (beta) via kubelet
`memorySwap.swapBehavior` (`NoSwap` default, or `LimitedSwap`). Historically K8s required swap
**off**; now it can be used carefully.

**Why it matters (security).** Swap writes memory contents — potentially **secrets, keys,
decrypted data** — to disk, where they may persist and be recovered (forensic/data-at-rest
risk). Swap also complicates memory limits/OOM behavior and can degrade performance
unpredictably (availability).

**Guidance**
- Default/safest: **`NoSwap`** for nodes handling sensitive data (regulated/PCI/HIPAA).
- If enabled (`LimitedSwap`): **encrypt the swap device** (dm-crypt/LUKS — [Linux/09](../../../linux-security/09-secure-boot-and-luks/)), only for Burstable/BestEffort, monitor closely.
- Never let secret-bearing pods swap to unencrypted disk.

**Example**
```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
failSwapOn: false
memorySwap: { swapBehavior: LimitedSwap }
```
**Cross-links:** [Linux/09 — LUKS](../../../linux-security/09-secure-boot-and-luks/), [Node-pressure Eviction](../../03-scheduling-preemption-eviction/16-node-pressure-eviction/).
