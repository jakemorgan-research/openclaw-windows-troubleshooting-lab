# Offline worked example

[Home](../README.md)

Input: [synthetic-diagnostic.txt](synthetic-diagnostic.txt). Expected result: [expected-sanitized.txt](expected-sanitized.txt). The fake sensitive line is deliberately marked as a non-credential.

From the repository root in PowerShell:

```powershell
./scripts/collect_openclaw_diagnostics.ps1 -SelfTest
./scripts/collect_openclaw_diagnostics.ps1 -InputPath examples/synthetic-diagnostic.txt -OutputPath openclaw-diagnostics-demo.txt
```

The output should preserve the useful status lines and replace the fake password line. If the output already exists, choose a different output filename; the helper will not overwrite it.

The helper reads one UTF-8 text file of at most 1 MiB and writes one new copy. It never starts OpenClaw or uploads anything. Do not give it a complete configuration file.

For the next step, compare the [synthetic case report](sanitized-case-report.md). Redaction is not diagnosis: the unresolved downstream result still needs a bounded check.
