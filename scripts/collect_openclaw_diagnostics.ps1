[CmdletBinding()]
param(
    [string]$OutputPath = "openclaw-diagnostics-sanitized.txt",
    [switch]$SelfTest
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
    $safe = $safe -replace '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b', '<email>'
    $safe = $safe -replace '(?i)https?://[^\s"''<>]+', '<url>'
    $safe = $safe -replace '\b(?:\d{1,3}\.){3}\d{1,3}\b', '<ip>'
    $safe = $safe -replace '(?i)\b(?:[0-9A-F]{2}[:-]){5}[0-9A-F]{2}\b', '<mac>'
    $safe = $safe -replace '(?i)\b[0-9A-F]{8}-[0-9A-F]{4}-[1-5][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}\b', '<uuid>'
    $safe = $safe -replace '(?i)\bBearer\s+[A-Za-z0-9._~+/-]+=*', 'Bearer <redacted>'
    $safe = $safe -replace '(?im)^.*(?:token|secret|password|api[_-]?key).*$', '<redacted-sensitive-line>'
    $safe = $safe -replace '\b\d{8,}\b', '<numeric-id>'
    return $safe
}

if ($SelfTest) {
    $testEmail = 'person' + '@' + 'example.com'
    $testUser = 'sample' + '-user'
    $testPath = 'C:\' + 'Users\' + $testUser + '\private'
    $testIp = @('192', '0', '2', '10') -join '.'
    $testToken = 'example-value-' + 'with-length'
    $testId = '12345' + '67890'
    $sample = 'account=' + $testEmail + "`n" +
        'path=' + $testPath + "`n" +
        'endpoint=https://' + 'private.invalid/path' + "`n" +
        'address=' + $testIp + "`n" +
        'authorization=Bearer ' + $testToken + "`n" +
        'session=' + $testId
    $sanitized = Protect-Text $sample
    $forbidden = @($testEmail, $testUser, 'private.invalid', $testIp, $testToken, $testId)
    foreach ($value in $forbidden) {
        if ($sanitized.Contains($value)) { throw "Redaction self-test failed." }
    }
    Write-Output 'Redaction self-test passed.'
    exit 0
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
Write-Output 'Wrote sanitized diagnostics file.'
Write-Warning 'Review the file manually before sharing. Automated redaction is not a guarantee.'
