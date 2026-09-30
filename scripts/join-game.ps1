# For a PARTNER who also has Claude: copies your friend's game (from their GitHub) onto this PC.
# Your friend's Claude must add you first (/teamup). Started by double-clicking 3-JOIN-A-FRIENDS-GAME.bat.
param([string]$Repo, [string]$Parent)

$ErrorActionPreference = "Continue"
$env:Path = "$env:USERPROFILE\.rokit\bin;C:\Program Files\GitHub CLI;C:\Program Files\Git\cmd;$env:Path"

Write-Host "`n==== Join a friend's game ====`n" -ForegroundColor Cyan
gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Log in to GitHub first: double-click 1-SETUP.bat." -ForegroundColor Red; exit 1 }

if (-not $Repo) {
    Write-Host "Your friend's Claude gives you the game's GitHub name (looks like  friendname/game-name )."
    Write-Host "Check your email or github.com/notifications and ACCEPT the invite first."
    $Repo = Read-Host "Game's GitHub name"
}
$Repo = $Repo.Trim() -replace "^https://github.com/", "" -replace "\.git$", ""
if (-not $Parent) { $Parent = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "RobloxGames" }
New-Item -ItemType Directory -Force $Parent | Out-Null
$target = Join-Path $Parent ($Repo.Split("/")[-1])
if (Test-Path $target) { Write-Host "You already have it at $target" -ForegroundColor Yellow }
else {
    gh repo clone $Repo $target 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Host "Couldn't download it. Did you accept the GitHub invite? Is the name right?" -ForegroundColor Red; exit 1 }
    Write-Host "Downloaded to $target" -ForegroundColor Green
}
Push-Location $target
rokit install --no-trust-check 2>&1 | Out-Null
Pop-Location

Set-Clipboard -Value $target -ErrorAction SilentlyContinue
Write-Host "`n==== Done! ====" -ForegroundColor Cyan
Write-Host "Next:"
Write-Host "  1. Open Roblox Studio and open the game from Roblox (it's under 'Shared with me' / Collaborations)."
Write-Host "     Don't press Connect in the Rojo plugin: your friend's computer does that part."
Write-Host "  2. Open the Claude app > Code tab > choose this folder: $target"
Write-Host "  3. Type:  Read CLAUDE.md. I'm the partner on this game, get me set up."
Start-Process explorer.exe $target
