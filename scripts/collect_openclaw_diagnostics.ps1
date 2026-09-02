[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath = "openclaw-diagnostics-sanitized.txt",
    [switch]$SelfTest
)

# Historical filename retained. This helper is deliberately offline-only.
$ErrorActionPreference = "Stop"
$MaxInputBytes = 1048576

function Protect-Text {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    $safe = $Text
    $safe = $safe -replace '(?i)[A-Z]:\\Users\\[^\\\s]+', '<user-path>'
    $safe = $safe -replace '(?i)/(?:home|Users)/[^/\s]+', '<user-path>'
    foreach ($identity in @($env:USERNAME, $env:COMPUTERNAME)) {
        if ($identity) { $safe = [regex]::Replace($safe, [regex]::Escape($identity), '<local-identity>', 'IgnoreCase') }
    }
    $safe = $safe -replace '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b', '<email>'
    $safe = $safe -replace '(?i)(?:https?|wss?)://[^\s"''<>]+', '<url>'
    $safe = $safe -replace '\b(?:\d{1,3}\.){3}\d{1,3}\b', '<ip>'
    $safe = $safe -replace '(?i)(?<![a-z0-9])(?:[0-9a-f]{0,4}:){2,}[0-9a-f:.%a-z0-9-]*', '<ipv6>'
    $safe = $safe -replace '(?i)\b(?:[0-9A-F]{2}[:-]){5}[0-9A-F]{2}\b', '<mac>'
    $safe = $safe -replace '(?i)\b[0-9A-F]{8}-(?:[0-9A-F]{4}-){3}[0-9A-F]{12}\b', '<uuid>'
    $safe = $safe -replace '(?i)\bBearer\s+[A-Za-z0-9._~+/-]+=*', 'Bearer <redacted>'
    $safe = $safe -replace '(?i)\b(?:sk-[a-z0-9_-]{12,}|gh[pousr]_[a-z0-9_]{16,}|github_pat_[a-z0-9_]{16,})', '<credential>'
    $safe = $safe -replace '\b\d{6,}:[A-Za-z0-9_-]{20,}\b', '<bot-credential>'
    $safe = $safe -replace '(?is)-----BEGIN [^-]*PRIVATE KEY-----.*?-----END [^-]*PRIVATE KEY-----', '<private-key>'
    $safe = $safe -replace '(?im)^.*(?:token|secret|password|api[_-]?key|chat[_-]?id|session[_-]?id|device[_-]?id|machine[_-]?name|host[_-]?name).*$','<redacted-sensitive-line>'
    $safe = $safe -replace '(?<!\d)\+?\d[\d ()-]{7,}\d(?!\d)', '<numeric-id>'
    return $safe
}

function Write-NewSanitizedFile {
    param([string]$Source, [string]$Destination)
    $sourceItem = Get-Item -LiteralPath $Source
    if ($sourceItem.PSIsContainer -or $sourceItem.Length -gt $MaxInputBytes) { throw "Input must be a text file no larger than 1 MiB." }
    $encoding = New-Object System.Text.UTF8Encoding($false, $true)
    $text = [IO.File]::ReadAllText($sourceItem.FullName, $encoding)
    $safe = Protect-Text $text
    $bytes = [Text.Encoding]::UTF8.GetBytes($safe)
    # CreateNew prevents accidental overwrite, including when input and output match.
    $stream = [IO.File]::Open($Destination, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $stream.Write($bytes, 0, $bytes.Length) } finally { $stream.Dispose() }
}

if ($SelfTest) {
    $email = 'person' + '@' + 'example.com'
    $userPath = 'D:\' + 'Users\' + 'fixture-person'
    $ip = @('192','0','2','10') -join '.'
    $ipv6 = '2001' + ':db8::abcd'
    $key = 'sk-' + ('a' * 28)
    $numeric = '12345' + '67890'
    $url = 'wss://' + 'private.invalid/socket'
    $cases = @($email, $userPath, $ip, $ipv6, $key, $numeric, $url,
        ('Bearer ' + ('b' * 30)), ('host' + 'name=fixture-device'))
    foreach ($sample in $cases) {
        if ((Protect-Text $sample).Contains($sample)) { throw "Redaction self-test failed (value withheld)." }
    }
    if ((Protect-Text 'Gateway running; result pending.') -ne 'Gateway running; result pending.') {
        throw "Benign text was changed."
    }
    $tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('openclaw-helper-test-' + [guid]::NewGuid().ToString('N'))
    [void][IO.Directory]::CreateDirectory($tempRoot)
    $source = Join-Path $tempRoot 'input.txt'
    $dest = Join-Path $tempRoot 'output.txt'
    try {
        [IO.File]::WriteAllText($source, $email)
        Write-NewSanitizedFile $source $dest
        if ([IO.File]::ReadAllText($dest) -ne '<email>') { throw "Output test failed." }
        $refused = $false
        try { Write-NewSanitizedFile $source $dest } catch { $refused = $true }
        if (-not $refused) { throw "Overwrite guard failed." }
        if ([IO.File]::ReadAllText($source) -ne $email) { throw "Input changed." }
        [IO.File]::WriteAllBytes($source, [byte[]]@(255, 255))
        $refused = $false
        try { Write-NewSanitizedFile $source (Join-Path $tempRoot 'invalid.txt') } catch { $refused = $true }
        if (-not $refused) { throw "Encoding guard failed." }
    } finally {
        # Exact files created by this test only; no recursive directory deletion.
        foreach ($leaf in @('input.txt', 'output.txt', 'invalid.txt')) {
            $item = Join-Path $tempRoot $leaf
            if ([IO.File]::Exists($item)) { [IO.File]::Delete($item) }
        }
        [IO.Directory]::Delete($tempRoot)
    }
    Write-Output 'PASS: redaction, benign text, output, overwrite, source preservation, and encoding guards.'
    exit 0
}

if (-not $InputPath) {
    Write-Output 'Usage: ./scripts/collect_openclaw_diagnostics.ps1 -InputPath <short-text-file> [-OutputPath <new-file>]'
    Write-Output 'Offline-only. Does not run OpenClaw, read configuration, repair, or upload.'
    exit 2
}
try {
    Write-NewSanitizedFile $InputPath $OutputPath
    Write-Output 'Wrote a new redacted text copy. Review manually before sharing; redaction is not a guarantee.'
} catch {
    # Do not echo exception messages: they can include paths or private text.
    Write-Output 'FAIL: input unreadable, oversized, invalid UTF-8, or destination already exists/is unwritable. No automatic retry.'
    exit 1
}
