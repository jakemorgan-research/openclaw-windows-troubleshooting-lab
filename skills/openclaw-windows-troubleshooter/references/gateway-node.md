# Gateway and Windows Node

Treat the Gateway and Windows Node as different components with different roles, versions, permissions, and failure modes.

```text
Agent exec request
  -> Gateway host selection
  -> eligible paired node resolution
  -> node command policy / approval
  -> Windows Node capability
  -> local executor
```

## Diagnostic split

- If Gateway status fails, repair lifecycle or connectivity first.
- If the node is absent, inspect pairing and transport.
- If lightweight node capabilities succeed but `system.run` fails, inspect command approval and the Windows executor rather than reinstalling the Gateway.
- If a command unexpectedly runs in Linux, verify the effective exec host. Do not assume an automatically selected host means Windows.

## Version language

Never infer incompatibility solely because Gateway and companion components use different-looking version numbers. Confirm compatibility in current official release notes or reproduce the boundary failure.

Official node behavior changes over time. When a historical case and current documentation disagree, label the old case as historical and follow the current documentation.

