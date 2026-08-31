[CmdletBinding()]
param(
    [string]$OutputPath = "openclaw-diagnostics-sanitized.txt"
)

$ErrorActionPreference = "Continue"

function Protect-Text {
    param([string]$Text)

    if ($null -eq $Text) { return "" }
    $safe = $Text
    if ($env:USERNAME) { $safe = $safe.Replace($env:USERNAME, "<user>") }
    if ($env:COMPUTERNAME) { $safe = $safe.Replace($env:COMPUTERNAME, "<host>") }
    $safe = $safe -replace '(?i)C:\\Users\\[^\\\s]+', 'C:\Users\<user>'
    $safe = $safe -replace '(?i)/home/[^/\s]+', '/home/<user>'
    $safe = $safe -replace '\b(?:\d{1,3}\.){3}\d{1,3}\b', '<ip>'
    $safe = $safe -replace '(?im)^.*(?:token|secret|password|api[_-]?key).*$', '<redacted-sensitive-line>'
    $safe = $safe -replace '\b\d{8,}\b', '<numeric-id>'
    return $safe
}

$commands = @(
    @{ Name = 'version'; Args = @('--version') },
    @{ Name = 'status'; Args = @('status') },
    @{ Name = 'gateway-status'; Args = @('gateway', 'status') },
    @{ Name = 'doctor'; Args = @('doctor') },
    @{ Name = 'channel-probe'; Args = @('channels', 'status', '--probe') }
)

$sections = New-Object System.Collections.Generic.List[string]
$sections.Add('# Sanitized OpenClaw diagnostics')
$sections.Add('Generated locally. Raw logs, configuration files, environment variables, and message contents are intentionally excluded.')

if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
    $sections.Add("`n## Result`nOpenClaw executable was not found in this shell environment.")
} else {
    foreach ($entry in $commands) {
        $raw = & openclaw @($entry.Args) 2>&1 | Out-String
        $sections.Add("`n## $($entry.Name)`n" + (Protect-Text $raw).Trim())
    }
}

$result = $sections -join "`n"
Set-Content -LiteralPath $OutputPath -Value $result -Encoding utf8
Write-Output "Wrote sanitized diagnostics to $OutputPath"
Write-Warning 'Review the file manually before sharing. Automated redaction is not a guarantee.'

