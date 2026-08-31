---
name: openclaw-windows-troubleshooter
description: Diagnose OpenClaw failures across Windows, WSL2, Gateway, Windows Node, proxy, and Telegram layers using evidence-first checks. Use when OpenClaw is installed but commands, node execution, channels, or delivery behave inconsistently; do not use for generic Windows repair or unverified installation advice.
---

# OpenClaw Windows Troubleshooter

Locate the first failing boundary before changing configuration. Prefer current official OpenClaw documentation and observable command output over remembered version-specific behavior.

## Workflow

1. Restate the symptom and identify the expected path: client -> Gateway -> node or channel -> external service -> receiving device.
2. Record only sanitized environment facts: OS family, WSL/network mode, OpenClaw component versions, and whether each component is reachable.
3. Run the smallest relevant checks from [references/triage.md](references/triage.md). Do not begin with reinstalling, changing ACLs, disabling sandboxing, or regenerating credentials.
4. Classify the failure layer:
   - Gateway lifecycle or WebSocket
   - Gateway-to-node routing or approval
   - Windows Node execution or sandbox
   - WSL-to-proxy reachability
   - channel/API delivery
   - receiving-app notification
5. Separate direct evidence from inference. Use `confirmed`, `likely`, or `unverified` for every root-cause statement.
6. Recommend one reversible next check. State the expected result for both branches.

## Safety and privacy

- Never request or reproduce API keys, bot tokens, passwords, full configuration files, message contents, user IDs, machine names, usernames, public IPs, or unredacted logs.
- Treat tokens shown in screenshots or logs as compromised and recommend rotation through the provider's official flow.
- Do not modify industrial-software directories, ACLs, DACLs, AppContainer policy, firewall rules, or proxy exposure merely to make a diagnostic pass.
- Do not tell users to enable LAN proxy access without also requiring binding, firewall, and trust-boundary review.
- A timeout is not proof of failure if the downstream action later succeeds. Check the final delivery event or provider response.
- Stop at authentication, approval, CAPTCHA, moderation, or account-security boundaries and ask the operator to complete them.

## Routing

- For first-pass checks, read [references/triage.md](references/triage.md).
- For Windows/WSL proxy boundaries, read [references/wsl-network.md](references/wsl-network.md).
- For Gateway and Windows Node routing, read [references/gateway-node.md](references/gateway-node.md).
- For `system.run`, ProcessContainer, or DACL symptoms, read [references/windows-sandbox.md](references/windows-sandbox.md).
- For Telegram delivery versus iOS notification symptoms, read [references/telegram-delivery.md](references/telegram-delivery.md).
- To prepare a shareable case, run `scripts/collect_openclaw_diagnostics.ps1`, inspect the result manually, and use [references/case-report.md](references/case-report.md).

## Completion standard

Finish with: failing boundary, supporting evidence, uncertainty, lowest-risk next action, rollback or stop condition, and any facts that still require official verification.
