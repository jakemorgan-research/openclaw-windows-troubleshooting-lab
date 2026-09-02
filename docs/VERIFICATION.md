# Verification boundary

Review date: 2026-09-02. Status: private development, no Release.

Local review: 7 Python test methods passed; self-tests passed in Windows PowerShell 5.1 and PowerShell 7; the generated synthetic output matched the expected fixture. Both original SVG diagrams were rendered and visually inspected. Skill frontmatter and workflow/issue YAML parsed successfully. Repository and local reachable-history privacy scans reported no configured matches. These are local checks; inspect the current GitHub Actions run for remote CI evidence.

| Layer | Evidence / limit |
| --- | --- |
| Offline helper | Synthetic redaction, benign-text preservation, output, no-overwrite, source-preservation, encoding tests |
| Data collection | No automatic commands, configuration reads, or uploads |
| Input scope | One UTF-8 file, maximum 1 MiB; not arbitrary binary logs |
| Documentation | Local links and SVG structure checked by script |
| Privacy | Pattern-based text checks; manual review still necessary |
| Live Windows / WSL / Telegram | Recipes, not an end-to-end reproduced integration claim |

## Compatibility and acceptance

Python checks target Python 3.9+. The helper targets Windows PowerShell 5.1 and PowerShell 7. CI exercises synthetic inputs; it does not authenticate to real services.

Before a public release, run both PowerShell variants, review all tracked files and reachable history, and accept a sanitized end-to-end reproduction on a recorded OpenClaw version. Do not publish private setup details as proof.

## Deliberate limitations

The redactor can over-redact useful text and can miss names, unusual secrets, split credentials, custom paths, encoded content, or nonstandard identifiers. It is not an anonymization guarantee. Do not use its output as automatic permission to share.

The historical script filename is retained for existing links; its former automatic command collection has been removed. Use the manual checks in the triage guide only when appropriate.
