# API Priority and Fairness (APF)

**What it is.** APF protects the apiserver from overload by classifying inbound requests into
**FlowSchemas** → **PriorityLevelConfigurations**, giving each a fair share of concurrency and
**queuing/rejecting (429)** excess — so one noisy client can't starve the control plane.

**Why it matters (security).** APF is the built-in defense against **API-server DoS** (a
runaway or malicious client flooding the API). It ensures **critical/system traffic keeps
flowing** during a storm, preserving availability and your ability to respond.

**Example — isolate a workload's flow**
```yaml
apiVersion: flowcontrol.apiserver.k8s.io/v1
kind: FlowSchema
metadata: { name: limit-tenant-a }
spec:
  priorityLevelConfiguration: { name: workload-low }
  matchingPrecedence: 1000
  rules:
    - subjects: [{ kind: ServiceAccount, serviceAccount: { name: "*", namespace: tenant-a } }]
      resourceRules: [{ verbs: ["*"], apiGroups: ["*"], resources: ["*"], namespaces: ["tenant-a"] }]
```
**Best practices:** keep APF enabled; give system/leader-election high priority; cap chatty
tenants/controllers; monitor `apiserver_flowcontrol_rejected_requests_total`.
**Cross-links:** [Metrics — System Components](../05-metrics-for-system-components/), [control-plane security](../../../kubernetes-security/01-control-plane-security/).
