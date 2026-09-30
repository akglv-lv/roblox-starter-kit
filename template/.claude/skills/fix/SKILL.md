---
name: fix
description: Find and fix something broken in the dev's Roblox game. Use when they type /fix, or say something is broken, doesn't work, errors, glitches or lags.
---

# /fix: something's broken

1. Ask (only if they didn't say): what did you do, what did you expect, what happened instead? One short question, not a form.
2. Look before guessing:
   - Studio Output (red errors, orange warnings) via the MCP console output.
   - `git log --oneline -10` and `git diff`: what changed recently is the usual suspect.
   - Reproduce it in a playtest (fresh save) and take a screenshot.
3. Find the real cause, not just the symptom. Fix it in the files on disk (never in Studio's script editor while Rojo is connected).
4. Run the checks (`stylua`, `selene`, `lune run tests/config`), playtest again, and confirm it's gone.
5. Commit and push. Tell them in plain words: what was wrong, what you changed, and a one-sentence lesson ("the coin was checked before the save loaded, so it gave nothing").
6. Lag? Check `docs/GAME-TIPS.md` section 3 first: too many parts, loops that move things, unanchored parts, connections never cleaned up, remotes fired every frame.
