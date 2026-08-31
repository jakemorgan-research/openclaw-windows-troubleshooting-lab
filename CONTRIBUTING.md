# Contributing

Contributions should make one failing boundary easier to identify or one diagnostic step safer to run.

## Before opening an issue

- Reproduce on a current supported OpenClaw release when practical.
- Check the upstream OpenClaw and Windows Node documentation/issues.
- Reduce the report to one symptom and one comparison probe.
- Remove tokens, IDs, contact details, usernames, machine names, IP addresses, local paths, message content, and private screenshots.

## Pull requests

- Keep product-specific commands linked to an official source.
- Label historical observations as historical.
- Avoid destructive repair steps and broad security-policy changes.
- Add or update a validation example when behavior changes.
- Run `python scripts/validate_repo.py` and the skill validator.

Do not submit real credentials for testing. Maintainers will close or redact unsafe reports rather than diagnose them publicly.

