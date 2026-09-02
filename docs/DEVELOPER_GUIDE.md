# Developer guide

[Home](../README.md) · [中文入门](GETTING_STARTED.zh-CN.md) · [Verification](VERIFICATION.md)

## Smallest useful contribution

Pick one failing synthetic case. Add a regression test, make the narrow fix, update the guide, and explain what remains unverified. A docs clarification is useful too.

## Local checks

Run from the repository root with Python 3.9+:

```text
python scripts/validate_repo.py
python scripts/check_docs.py
python -m unittest discover -s tests -v
```

On Windows also run `./scripts/collect_openclaw_diagnostics.ps1 -SelfTest`. PowerShell 5.1+ is required for this helper.

## Repository map

| Directory | Responsibility |
| --- | --- |
| `SKILL.md` + `references/` | Agent decisions and conditional guidance |
| `examples/` | Synthetic inputs and expected outcomes |
| `scripts/` | Offline checks; no automatic upload |
| `tests/` | Behavioral regressions |
| `docs/media/` | Original, text-readable SVG diagrams |
| `.github/` | Checks, issue forms, and PR review |

## Review contract

Do not broaden the tool's runtime privileges to make a test pass. Keep offline tests independent of credentials and OpenClaw installation. CI exercises helpers, not a connected Gateway. The privacy scanner reports locations and categories, never matching values.

## Feedback path

Use **Issues → New issue → Reproducible problem** for behavior, or **Beginner feedback** for an unclear guide. During private review, only invited collaborators can access these forms. No public feedback is implied.

## Delivery boundary

To roll back, reinstall the previously reviewed Git commit. To remove the companion, use your installation record to identify its exact installed skill directory and remove only that copy after review; do not remove bundled skills or the whole skills directory. Refresh the active session and confirm the companion no longer appears. This repository does not automate uninstall.

This is a Git-installable skill plus a source toolkit. There is no published Release in this review stage. Review the source, use a pinned commit for reproducible installation, and test in a non-sensitive environment before relying on it.
