---
name: update-kit
description: Update this game folder's Claude commands, tips and settings to the newest Starter Kit version, without touching the game itself. Use when the dev types /update-kit or says their sibling/friend improved the kit.
---

# /update-kit: get the newest commands and tips

1. Download `https://github.com/akglv-lv/roblox-starter-kit/archive/refs/heads/main.zip` to a temp folder and unzip it. Also refresh the kit folder in Documents (`Documents\Roblox Starter Kit`) with it.
2. From the kit's `template/`, copy into this game folder, replacing the old copies:
   - `.claude/skills/*` (all command folders)
   - `docs/GAME-TIPS.md`
   - `scripts/watch-pull.ps1`
3. Merge, don't replace:
   - `.claude/settings.json`: add any new `permissions.allow` entries; keep entries this game already has.
   - `CLAUDE.md`: bring in new or changed general sections (rules, tools, commands list), but KEEP this game's own parts: the game name, the filled-in **Working together** section, and anything written specifically about this game. Show a 3-line summary of what changed.
   - `docs/PARTNER.md`: update the general text, keep the game name.
4. **Never touch** `src/`, `tests/`, `default.project.json`, `IDEAS.md`, `docs/MY-GAME.md`, or the Studio place.
5. Commit ("Update Starter Kit commands and tips") and push. Tell the dev in one or two lines what's new (e.g. "New: /thumbnail and /launch-ready").
