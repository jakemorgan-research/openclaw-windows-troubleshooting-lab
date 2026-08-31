# OpenClaw Windows Troubleshooting Lab

Evidence-first diagnostics for OpenClaw on Windows + WSL2.

> Private preview. This repository is not affiliated with or endorsed by OpenClaw.

## What this gives you

```text
Symptom
  -> identify the failing boundary
  -> run one reversible comparison check
  -> separate evidence from inference
  -> produce a sanitized case report
```

The included `openclaw-windows-troubleshooter` skill helps developers and beginners distinguish:

- Gateway lifecycle from model or channel failures
- Gateway-to-node routing from Windows execution failures
- WSL proxy reachability from upstream TLS instability
- Telegram Bot API delivery from iPhone notification behavior
- caller timeouts from confirmed downstream failures

## Start in five minutes

1. Open [`skills/openclaw-windows-troubleshooter/SKILL.md`](skills/openclaw-windows-troubleshooter/SKILL.md).
2. Follow the first-pass boundary map in [`references/triage.md`](skills/openclaw-windows-troubleshooter/references/triage.md).
3. On Windows, optionally run the read-only collector:

   ```powershell
   .\skills\openclaw-windows-troubleshooter\scripts\collect_openclaw_diagnostics.ps1
   ```

4. Manually review the generated file before sharing it.
5. Use the [sanitized case template](skills/openclaw-windows-troubleshooter/references/case-report.md) for an issue or discussion.

## Pick your symptom

| Symptom | Start here |
|---|---|
| Gateway is offline or dashboard disconnects | [First-pass triage](skills/openclaw-windows-troubleshooter/references/triage.md) |
| Command runs in Linux instead of Windows | [Gateway and Windows Node](skills/openclaw-windows-troubleshooter/references/gateway-node.md) |
| `system.run` times out or mentions sandbox/DACL | [Windows sandbox](skills/openclaw-windows-troubleshooter/references/windows-sandbox.md) |
| WSL cannot reliably reach the proxy/service | [WSL networking](skills/openclaw-windows-troubleshooter/references/wsl-network.md) |
| Telegram sends but the phone does not notify | [Telegram delivery](skills/openclaw-windows-troubleshooter/references/telegram-delivery.md) |

## Repository boundary

This project deliberately excludes private configuration, raw logs, tokens, bot/chat IDs, machine names, usernames, contact details, proxy endpoints, local paths, screenshots of private dashboards, and third-party assets.

Historical cases are rewritten as generalized diagnostic patterns. They are not presented as current universal bugs. Commands and configuration must be checked against current official documentation before use.

## Official references

- [OpenClaw channel troubleshooting](https://github.com/openclaw/openclaw/blob/main/docs/channels/troubleshooting.md)
- [OpenClaw Telegram channel](https://github.com/openclaw/openclaw/blob/main/docs/channels/telegram.md)
- [OpenClaw nodes](https://github.com/openclaw/openclaw/blob/main/docs/nodes/index.md)
- [OpenClaw skills](https://github.com/openclaw/openclaw/blob/main/docs/tools/skills.md)
- [Windows Node Gateway/exec FAQ](https://github.com/openclaw/openclaw-windows-node/blob/main/docs/OPENCLAW_GATEWAY_NODE_EXEC_FAQ.md)

Links were last checked on 2026-08-31. OpenClaw evolves quickly; prefer the current upstream default branch and releases.

## Development

```text
python scripts/validate_repo.py
python <skill-creator>/scripts/quick_validate.py skills/openclaw-windows-troubleshooter
```

See [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a reproduction. Security-sensitive reports belong in a private maintainer channel, not a public issue.

## License

MIT. Documentation and examples are provided without warranty.

