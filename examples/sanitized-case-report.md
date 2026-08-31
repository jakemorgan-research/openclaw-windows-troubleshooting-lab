# Example: sanitized boundary report

## Symptom

A command request reaches the Gateway, but the expected Windows-side process does not start.

## Environment

- Windows: supported desktop release, exact build withheld
- WSL: enabled; networking mode not yet verified
- OpenClaw: component versions recorded locally and omitted from this example
- Topology: Gateway host -> paired Windows node

## Reproduction

1. Confirm the node appears connected.
2. Run one lightweight node capability.
3. Run one minimal process-execution probe.

Expected: both probes return successfully.

Actual: the lightweight capability returns; the process-execution probe reaches its caller timeout.

## Evidence

- Confirmed: pairing and lightweight node transport work.
- Likely: the first failing boundary is Windows process execution or its approval policy.
- Unverified: the downstream process may still complete after the caller timeout.

## Lowest-risk next check

Inspect the final node-side result for the same request. If completion is recorded, treat this as timeout/reporting behavior. If no process starts, inspect the current execution approval and sandbox documentation without changing ACLs.

## Privacy review

- [x] no credentials, tokens, contact details, node IDs, machine names, private paths, addresses, or message content

