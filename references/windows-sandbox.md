# Windows `system.run`, sandbox, and DACL symptoms

This guide is for symptoms such as:

```text
system.run timeout
ProcessContainer or AppContainer initialization failure
DACL fallback or access denied
lightweight node calls work while process execution fails
```

## Evidence-first sequence

1. Confirm that the request reached the intended Windows node.
2. Compare a lightweight capability with one minimal process-execution probe.
3. Capture the executor tier and the smallest relevant error.
4. Check current official Windows Node documentation and open issues for the exact build/component combination.
5. Report the result without changing protected directories or granting broad ACL rights.

## What not to do

- Do not grant `WRITE_DAC` broadly.
- Do not recursively change ownership of application or industrial-software directories.
- Do not disable AppContainer, ProcessContainer, antivirus, or Windows security features as a speculative fix.
- Do not call a version mismatch confirmed unless the maintainers document it or a controlled comparison proves it.

## Historical lesson

A prior sanitized case showed a useful diagnostic pattern: device/canvas calls returned normally while `system.run` stalled during Windows sandbox initialization. That pattern localized the problem to execution rather than pairing. It does not prove every current `system.run` failure has the same cause.
