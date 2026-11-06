# Keep the configured merged DLC pack when refreshing the launcher LAN URL.
# ASCII source is intentional: start.bat invokes Windows PowerShell 5.1.
param([string]$ServerRoot = '')
$ErrorActionPreference = 'Stop'
if (-not $ServerRoot) { $ServerRoot = Split-Path -Parent $PSScriptRoot }
$props = Join-Path $ServerRoot 'server.properties'
$packDir = Join-Path $ServerRoot 'resourcepack'
$text = [System.IO.File]::ReadAllText($props, [System.Text.Encoding]::UTF8)
$file = $null
$match = [regex]::Match($text, '(?m)^resource-pack=(.+)$')
if ($match.Success) {
    $address = $match.Groups[1].Value.Trim().Replace('\:', ':')
    $uri = $null
    if ([Uri]::TryCreate($address, [UriKind]::Absolute, [ref]$uri)) {
        $configured = [Uri]::UnescapeDataString([System.IO.Path]::GetFileName($uri.AbsolutePath))
        if ($configured -and (Test-Path -LiteralPath (Join-Path $packDir $configured))) { $file = $configured }
    }
}
if (-not $file) {
    $latest = Get-ChildItem -LiteralPath $packDir -Filter 'panling-mirror-resourcepack-*.zip' |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) { $file = $latest.Name }
}
if (-not $file) { $file = 'panling-1.20-resourcepack-1.1.0b.zip' }
$pack = Join-Path $packDir $file
if (-not (Test-Path -LiteralPath $pack)) { throw "Resource pack does not exist: $pack" }
$ip = $null
try {
    $cfg = Get-NetIPConfiguration |
        Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.IPv4Address -ne $null } |
        Select-Object -First 1
    if ($cfg) { $ip = $cfg.IPv4Address.IPAddress }
} catch { }
if (-not $ip) { $ip = '127.0.0.1' }
$values = @{
    'resource-pack' = 'http://' + $ip + ':8080/' + $file
    'resource-pack-sha1' = (Get-FileHash -LiteralPath $pack -Algorithm SHA1).Hash.ToLowerInvariant()
}
foreach ($key in $values.Keys) {
    $pattern = '(?m)^' + [regex]::Escape($key) + '=.*$'
    $line = $key + '=' + $values[$key]
    if ($text -match $pattern) { $text = [regex]::Replace($text, $pattern, $line) }
    else { $text = $text.TrimEnd() + [Environment]::NewLine + $line + [Environment]::NewLine }
}
[System.IO.File]::WriteAllText($props, $text, (New-Object System.Text.UTF8Encoding($false)))
Write-Output $ip
