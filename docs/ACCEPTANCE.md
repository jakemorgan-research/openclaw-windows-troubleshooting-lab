# Recorded runtime acceptance

[Home](../README.md) · [Verification boundary](VERIFICATION.md) · [Synthetic case](../examples/sanitized-case-report.md)

Date: **2026-09-03**. Runtime: **OpenClaw 2026.8.2 (0965053)**, Node **24.15.0**, WSL2 on Windows. The helper was checked separately in native Windows PowerShell **5.1** and PowerShell **7**.

| Stage | Observed result |
| --- | --- |
| Clean source installation | Local tracked-files-only snapshot installed with `skills install <checkout> --global`; exit 0 |
| Skill discovery | `skills info openclaw-windows-troubleshooter --json`; exit 0, `eligible: true`, `disabled: false`, `source: openclaw-managed` |
| Native Windows helper | Synthetic self-tests passed in both PowerShell variants, including the copy installed in isolated managed state |
| Output contract | Sanitized fixture matched expected text; tests cover no-overwrite and preservation of input |
| Repository regression | 8 Python test methods passed |

Installation used fresh state, configuration, and workspace directories. The subprocess received only minimal runtime environment variables and isolated `OPENCLAW_STATE_DIR` / `OPENCLAW_CONFIG_PATH` values. No personal configuration, sessions, secrets, network proxy, permissions, or existing Gateway were changed. Raw installation output is withheld because it can contain private paths.

## Reproduce in a disposable environment

1. Review the source and pin a commit. Activate your runtime's documented isolated state/configuration options or use a disposable environment.
2. Run `openclaw --version` and `openclaw skills install . --global` from the checkout. Verify that the managed installation destination belongs to the isolated state; stop before replacing an unrelated skill.
3. Run `openclaw skills info openclaw-windows-troubleshooter --json`. Check eligibility and enabled status locally; do not share raw paths in the output.
4. In Windows PowerShell, run `./scripts/collect_openclaw_diagnostics.ps1 -SelfTest`. Repeat in PowerShell 7 if available. Run the [synthetic input/output example](../examples/README.md), inspect the result, and do not upload actual logs.

This verifies installation/discovery and the standalone helper. It does not prove automated reasoning quality or end-to-end Telegram, proxy, DACL, native Windows OpenClaw, or Gateway/node repairs. The recipes are conditional investigation guides, not a promise of automatic repair. See [removal and rollback](DEVELOPER_GUIDE.md#delivery-boundary).
