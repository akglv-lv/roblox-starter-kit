# Sets up this Windows PC for making Roblox games with Claude, Rojo and Roblox Studio.
# Safe to run again and again: every step checks first and skips what's already done.
# Started by double-clicking 1-SETUP.bat.
# Claude runs it as: setup.ps1 -GitName "..." -GitEmail "..." -NoLogin   (then does the GitHub login itself)
param([switch]$Check, [string]$GitName, [string]$GitEmail, [switch]$NoLogin)

$ErrorActionPreference = "Continue"
$kit = Split-Path -Parent $PSScriptRoot
$template = Join-Path $kit "template"
$results = New-Object System.Collections.ArrayList
function Note($status, $what, $detail) {
    [void]$results.Add([pscustomobject]@{ Status = $status; Step = $what; Detail = $detail })
    $color = switch ($status) { "OK" { "Green" } "WARN" { "Yellow" } default { "Red" } }
    Write-Host ("[{0}] {1}  {2}" -f $status, $what, $detail) -ForegroundColor $color
}
function Has($cmd) { return $null -ne (Get-Command $cmd -ErrorAction SilentlyContinue) }
function AddToPath($dir) {
    if (-not (Test-Path $dir)) { return }
    if (($env:Path -split ";") -notcontains $dir) { $env:Path = "$dir;$env:Path" }
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    if (($user -split ";") -notcontains $dir) {
        if ($Check) { return }
        [Environment]::SetEnvironmentVariable("Path", "$dir;$user", "User")
    }
}
function WingetInstall($id, $name) {
    if ($Check) { Note "WARN" $name "not installed"; return }
    if (-not (Has "winget")) { Note "FAIL" $name "winget is missing. Update 'App Installer' in the Microsoft Store, then run this again."; return }
    Write-Host "Installing $name ..." -ForegroundColor Cyan
    winget install --id $id --accept-source-agreements --accept-package-agreements -h | Out-Null
    Note "OK" $name "installed"
}

Write-Host "`n==== Roblox game dev setup ====`n" -ForegroundColor Cyan

# 1) Roblox Studio (can't be installed by script; it comes from roblox.com)
$studio = Get-ChildItem (Join-Path $env:LOCALAPPDATA "Roblox\Versions") -Filter RobloxStudioBeta.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($studio) { Note "OK" "Roblox Studio" "installed" }
else { Note "FAIL" "Roblox Studio" "not found. Get it at https://create.roblox.com (Start Creating), sign in, then run this again." }

# 2) Claude desktop app
if ((Test-Path (Join-Path $env:APPDATA "Claude")) -or (Get-AppxPackage -Name "*Claude*" -ErrorAction SilentlyContinue)) { Note "OK" "Claude app" "installed" }
else { WingetInstall "Anthropic.Claude" "Claude app" }

# 3) Git (saves every version of your game) and GitHub CLI (backs it up online)
if (Has "git") { Note "OK" "Git" (git --version) }
else { WingetInstall "Git.Git" "Git"; AddToPath "C:\Program Files\Git\cmd" }
AddToPath "C:\Program Files\GitHub CLI"
if (Has "gh") { Note "OK" "GitHub CLI" "installed" }
else { WingetInstall "GitHub.cli" "GitHub CLI"; AddToPath "C:\Program Files\GitHub CLI" }

# 4) Rokit, and through it Rojo (files -> Studio), Selene (finds mistakes), StyLua (tidies code), Lune (runs tests)
AddToPath "$env:USERPROFILE\.rokit\bin"
if (-not (Has "rokit")) { WingetInstall "rojo-rbx.Rokit" "Rokit"; AddToPath "$env:USERPROFILE\.rokit\bin" }
if (Has "rokit") {
    if (-not $Check) { Push-Location $template; rokit install --no-trust-check 2>&1 | Out-Null; Pop-Location }
    foreach ($tool in "rojo", "selene", "stylua", "lune") {
        if (Has $tool) { Note "OK" $tool "ready" }
        else { Note "FAIL" $tool "missing. Close this window and double-click 1-SETUP.bat again." }
    }
} else { Note "FAIL" "Rokit" "not installed. Close this window and double-click 1-SETUP.bat again." }

# 5) Rojo plugin inside Studio
$plugin = Join-Path $env:LOCALAPPDATA "Roblox\Plugins\RojoManagedPlugin.rbxm"
if (Test-Path $plugin) { Note "OK" "Rojo plugin" "installed in Studio" }
elseif ((Has "rojo") -and -not $Check) { rojo plugin install 2>&1 | Out-Null; Note "OK" "Rojo plugin" "installed (restart Studio if it's open)" }

# 6) Your name for saved versions
if (Has "git") {
    if (-not (git config --global user.name) -or -not (git config --global user.email)) {
        if ($Check) { Note "WARN" "Git name" "not set" }
        else {
            Write-Host "`nGit labels every save with a name and email." -ForegroundColor Cyan
            $n = if ($GitName) { $GitName } else { Read-Host "Your name (or nickname)" }
            $e = if ($GitEmail) { $GitEmail } else { Read-Host "The email you used for GitHub" }
            git config --global user.name $n; git config --global user.email $e
            Note "OK" "Git name" "$n"
        }
    } else { Note "OK" "Git name" (git config --global user.name) }
    if (-not (git config --global core.autocrlf)) { if (-not $Check) { git config --global core.autocrlf true } }
    if (-not (git config --global init.defaultBranch)) { if (-not $Check) { git config --global init.defaultBranch main } }
}

# 7) GitHub login (a browser window opens; type the code it shows)
if (Has "gh") {
    gh auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Note "OK" "GitHub login" "logged in" }
    elseif ($Check -or $NoLogin) { Note "WARN" "GitHub login" "not logged in yet" }
    else {
        Write-Host "`nLogging in to GitHub: copy the code it shows, then paste it in the browser page." -ForegroundColor Cyan
        gh auth login -h github.com -w -p https -s repo,workflow
        gh auth status 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { Note "OK" "GitHub login" "logged in" } else { Note "FAIL" "GitHub login" "didn't finish. Make a free account at github.com/signup, then run this again." }
    }
}

# 8) Let Claude see and control Roblox Studio (the MCP server)
$mcpBat = Join-Path $env:LOCALAPPDATA "Roblox\mcp.bat"
$claudeCfg = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
if (-not (Test-Path $mcpBat)) {
    Note "WARN" "Studio <-> Claude" "not switched on yet. In Roblox Studio: open the Assistant panel > gear (settings) > turn ON 'MCP server'. Then run this again."
} else {
    $cfg = if (Test-Path $claudeCfg) { Get-Content $claudeCfg -Raw | ConvertFrom-Json } else { [pscustomobject]@{} }
    if (-not $cfg.PSObject.Properties["mcpServers"]) { $cfg | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{}) }
    if ($cfg.mcpServers.PSObject.Properties["Roblox_Studio"]) { Note "OK" "Studio <-> Claude" "connected" }
    elseif ($Check) { Note "WARN" "Studio <-> Claude" "would connect" }
    else {
        if (Test-Path $claudeCfg) { Copy-Item $claudeCfg "$claudeCfg.bak" -Force }
        $entry = [pscustomobject]@{ command = "cmd.exe"; args = @("/c", "cd /d %LOCALAPPDATA%\Roblox && .\mcp.bat") }
        $cfg.mcpServers | Add-Member -NotePropertyName Roblox_Studio -NotePropertyValue $entry
        New-Item -ItemType Directory -Force (Split-Path $claudeCfg) | Out-Null
        $cfg | ConvertTo-Json -Depth 10 | Set-Content $claudeCfg -Encoding utf8
        Note "OK" "Studio <-> Claude" "connected. QUIT and reopen the Claude app (right-click its tray icon > Quit)."
    }
}

Write-Host "`n==== Summary ====" -ForegroundColor Cyan
$results | Format-Table -AutoSize | Out-String | Write-Host
$bad = @($results | Where-Object { $_.Status -ne "OK" })
if ($bad.Count -eq 0) {
    Write-Host "All set! Next: double-click 2-NEW-GAME.bat to make your first game." -ForegroundColor Green
} else {
    Write-Host "Fix the yellow/red lines above (each one says how), then double-click 1-SETUP.bat again." -ForegroundColor Yellow
}
