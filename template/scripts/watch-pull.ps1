# Keeps this clone up to date with GitHub without anyone remembering to pull.
#   powershell -ExecutionPolicy Bypass -File scripts\watch-pull.ps1            # every 30 s
#   powershell -ExecutionPolicy Bypass -File scripts\watch-pull.ps1 -Interval 10
# Every <Interval> seconds it fetches and, if GitHub is ahead and you have no uncommitted changes,
# fast-forwards. It never merges, never stashes and never touches your uncommitted work: if your
# tree is dirty it just tells you commits are waiting. Ctrl+C stops it.
# On the computer whose Studio has Rojo connected (the game owner), every pull lands in the shared Studio
# game a moment later, so both of you see it in Studio. Claude starts this for you in the background.
param(
    [int]$Interval = 30,
    [string]$Branch = "main"
)

$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo
$ErrorActionPreference = "Continue"

function Stamp { return (Get-Date).ToString("HH:mm:ss") }

Write-Host ""
Write-Host "watch-pull: $repo ($Branch) every $Interval s. Rojo will push pulled scripts into Studio if it is connected here. Ctrl+C to stop." -ForegroundColor Cyan
Write-Host ""

$lastWarning = ""
while ($true) {
    git fetch --quiet origin 2>$null
    $behind = [int](git rev-list --count "HEAD..origin/$Branch" 2>$null)
    $ahead = [int](git rev-list --count "origin/$Branch..HEAD" 2>$null)
    if ($behind -gt 0) {
        $dirty = (git status --porcelain 2>$null) -ne $null
        if ($ahead -gt 0) {
            $msg = "$behind commit(s) on GitHub but this clone has $ahead unpushed commit(s): run 'git pull' yourself to merge."
            if ($msg -ne $lastWarning) { Write-Host "$(Stamp) $msg" -ForegroundColor Red; $lastWarning = $msg }
        }
        elseif ($dirty) {
            $msg = "$behind commit(s) waiting on GitHub; commit or stash your changes and they'll come in."
            if ($msg -ne $lastWarning) { Write-Host "$(Stamp) $msg" -ForegroundColor Yellow; $lastWarning = $msg }
        }
        else {
            $incoming = git log --format="  %h %s (%an)" "HEAD..origin/$Branch" 2>$null
            git pull --ff-only --quiet origin $Branch 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$(Stamp) pulled $behind commit(s):" -ForegroundColor Green
                $incoming | ForEach-Object { Write-Host $_ }
                $lastWarning = ""
            }
            else {
                $msg = "pull failed; run 'git pull' yourself to see why."
                if ($msg -ne $lastWarning) { Write-Host "$(Stamp) $msg" -ForegroundColor Red; $lastWarning = $msg }
            }
        }
    }
    Start-Sleep -Seconds $Interval
}
