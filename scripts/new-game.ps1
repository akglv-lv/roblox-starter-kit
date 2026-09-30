# Makes a new Roblox game folder from the template, saves it with git and backs it up (privately) on GitHub.
# Started by double-clicking 2-NEW-GAME.bat.
param([string]$Name, [string]$Parent, [string]$Mode, [switch]$Offline)  # -Offline: no GitHub, no Explorer (for testing)

$ErrorActionPreference = "Stop"
$kit = Split-Path -Parent $PSScriptRoot
$template = Join-Path $kit "template"
$env:Path = "$env:USERPROFILE\.rokit\bin;C:\Program Files\GitHub CLI;C:\Program Files\Git\cmd;$env:Path"

Write-Host "`n==== Make a new game ====`n" -ForegroundColor Cyan
if (-not $Name) { $Name = Read-Host "What's your game called? (you can change it later)" }
$Name = ($Name -replace '["\\{}]', "").Trim() # these characters would break the code files the name goes into
if (-not $Name) { Write-Host "No name given." -ForegroundColor Red; exit 1 }
# Folder / GitHub names can't have special characters
$slug = ($Name -replace "[^A-Za-z0-9 _-]", "").Trim() -replace "\s+", "-"
if (-not $slug) { $slug = "my-roblox-game" }

if (-not $Parent) { $Parent = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "RobloxGames" }
New-Item -ItemType Directory -Force $Parent | Out-Null
$target = Join-Path $Parent $slug
if (Test-Path $target) { Write-Host "A game folder already exists at $target. Pick another name." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "  1 = a brand-new game (starts with a small working example you'll replace with your idea)"
Write-Host "  2 = a game you ALREADY started in Roblox Studio (Claude brings its scripts in first)"
$mode = if ($Mode) { $Mode } else { Read-Host "Type 1 or 2" }
$existing = $mode.Trim() -eq "2"

Copy-Item $template $target -Recurse
if ($existing) {
    # No example game: the real game's scripts get copied in from Studio by Claude (/start)
    Remove-Item -Recurse -Force (Join-Path $target "src\ServerScriptService\*"), (Join-Path $target "src\StarterPlayer\StarterPlayerScripts\*")
    Copy-Item (Join-Path $kit "existing\Config.lua") (Join-Path $target "src\ReplicatedStorage\Shared\Config.lua") -Force
    Copy-Item (Join-Path $kit "existing\config.luau") (Join-Path $target "tests\config.luau") -Force
    Copy-Item (Join-Path $kit "existing\IMPORT-FIRST.md") (Join-Path $target "IMPORT-FIRST.md")
    foreach ($keep in "src\ServerScriptService", "src\StarterPlayer\StarterPlayerScripts") { New-Item -ItemType File -Force (Join-Path $target "$keep\.gitkeep") | Out-Null }
    $ideas = Join-Path $target "IDEAS.md"
    [IO.File]::WriteAllText($ideas, ([IO.File]::ReadAllText($ideas) -replace "(?m)^- \[x\] Starter kit.*$", "- [x] Starter kit set up"), (New-Object Text.UTF8Encoding $false))
}
# Put the game's name into the files that mention it
foreach ($file in "default.project.json", "CLAUDE.md", "README.md", "IDEAS.md", "docs\PARTNER.md", "src\ReplicatedStorage\Shared\Config.lua") {
    $path = Join-Path $target $file
    $text = [IO.File]::ReadAllText($path)
    [IO.File]::WriteAllText($path, $text.Replace("{{GAME_NAME}}", $Name), (New-Object Text.UTF8Encoding $false))
}
Write-Host "Made $target" -ForegroundColor Green

Push-Location $target
try {
    rokit install --no-trust-check 2>&1 | Out-Null
    git init -b main 2>&1 | Out-Null
    $ErrorActionPreference = "Continue"
    # git labels every save with a name; 1-SETUP.bat normally sets it, but ask here if it didn't
    if (-not (git config user.name) -or -not (git config user.email)) {
        if ($Offline) { git config user.name "Test"; git config user.email "test@example.com" }
        else {
            git config --global user.name (Read-Host "Your name (or nickname) for saves")
            git config --global user.email (Read-Host "The email you used for GitHub")
        }
    }
    git add -A 2>&1 | Out-Null
    git commit -q -m "Start $Name from the starter kit" 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "Saved the first version with git" -ForegroundColor Green }
    else { Write-Host "Couldn't save with git. Claude can fix it: just tell it this message." -ForegroundColor Yellow }

    if (-not $Offline) { gh auth status 2>&1 | Out-Null } else { $global:LASTEXITCODE = 1 }
    if ($LASTEXITCODE -eq 0) {
        gh repo create $slug --private --source . --push 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { Write-Host "Backed up to GitHub (private: only you can see it)" -ForegroundColor Green }
        else { Write-Host "Couldn't make the GitHub backup (maybe the name is taken). Claude can do it later: just ask." -ForegroundColor Yellow }
    } else {
        Write-Host "Not logged in to GitHub, so no online backup yet. Run 1-SETUP.bat, or ask Claude later." -ForegroundColor Yellow
    }
} finally { Pop-Location }

Set-Clipboard -Value $target -ErrorAction SilentlyContinue
Write-Host "`n==== Done! ====" -ForegroundColor Cyan
Write-Host "Your game folder: $target  (copied to your clipboard)"
Write-Host "Next:"
Write-Host "  1. Open Roblox Studio."
Write-Host "  2. Open the Claude app > Code tab > choose this folder."
Write-Host "  3. Type:  /start"
if (-not $Offline) { Start-Process explorer.exe $target }
