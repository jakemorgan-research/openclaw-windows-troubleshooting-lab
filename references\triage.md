# First-pass triage

Use the smallest command ladder that can distinguish lifecycle, routing, and channel failures:

```text
openclaw status
openclaw gateway status
openclaw logs --follow
openclaw doctor
openclaw channels status --probe
```

Do not paste an entire log. Capture a short time window around one reproduced event, then redact it before sharing.

## Boundary map

```text
User request
  -> client or channel
  -> Gateway
     -> local tool, OR
     -> paired node, OR
     -> external channel API
  -> receiving application/device
```

## Evidence table

| Observation | What it proves | What it does not prove |
|---|---|---|
| Gateway reports running | Service lifecycle is active | Model, node, or channel calls will succeed |
| Node appears connected | Pairing and transport are present | `system.run` is approved or executable |
| `device.status` succeeds | Node can answer a lightweight capability | Process execution is healthy |
| Proxy TCP connect succeeds | Proxy listener is reachable | TLS and upstream routing are healthy |
| Telegram returns a message ID | Bot API accepted the send | iOS displayed a lock-screen notification |
| CLI times out | Caller stopped waiting | Downstream action definitely failed |

## Stop conditions

Stop destructive troubleshooting when the next step would change ACLs, secrets, firewall exposure, account state, or system security policy. Document the evidence and escalate to the relevant official issue or support channel.
