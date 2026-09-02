# First-pass triage

![Client, Gateway, node or channel, and result](../docs/media/workflow.svg)

Start with the smallest relevant operator-run check, not an automatic repair ladder.

| Question | Optional manual check | Meaning |
| --- | --- | --- |
| Is the CLI available? | `openclaw --version` | Installation visible in this shell |
| Is the service reachable? | `openclaw gateway status` | Does not prove model or channel success |
| Is the overall status healthy? | `openclaw status` | Inspect output privately |
| Can the channel respond? | `openclaw channels status --probe` | Active network probe; run only when relevant |

Commands depend on installed versions. The offline helper runs none of these.

`openclaw doctor` may enter diagnosis/repair workflows; it is not included in unattended collection. Inspect current help and obtain approval before repairs. Do not stream unlimited logs or paste full output.

## Evidence boundaries

A connected node does not prove process execution is approved. Proxy reachability does not prove upstream TLS is healthy. A Telegram send receipt does not prove the phone displayed a notification. A caller timeout does not prove a downstream action failed.

Use one controlled comparison and record both possible interpretations.

## Stop

Stop before changing credentials, ACLs, firewall exposure, sandbox rules, or account security. Consult current [OpenClaw troubleshooting](https://github.com/openclaw/openclaw/blob/main/docs/channels/troubleshooting.md) and the relevant platform guide.
