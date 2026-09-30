---
name: ship
description: Get the dev's Roblox game ready to publish an update to real players. Use when they type /ship or say "publish", "release", "put it on Roblox", "update the game".
---

# /ship: ready to publish

Publishing sends out EVERYTHING in the Studio place to real players, finished or not. Go through this, then the dev clicks Publish.

1. Checks: `stylua src tests`, `selene src --allow-warnings` (0 errors), `lune run tests/config` (0 failed), `rojo build -o build.rbxl` (then delete build.rbxl). Everything committed and pushed.
2. Studio has the latest scripts (Rojo connected; spot-check one changed script in Studio).
3. Clean the place: no leftover test parts or test scripts in Workspace/ServerStorage.
4. **Remove the `StudioFreshSave` attribute from Workspace** (it's ignored live, but keep things tidy).
5. Every Robux item has a real ID in Config (no `Id = 0` left for things meant to be sold).
6. `/test` run: fresh player, no red errors, phone view OK.
7. Tell the dev to click **File > Publish to Roblox**, then join the real game from the Roblox website once to check it loads and their save is there.
8. First publish ever? Remind them (one at a time) to set on create.roblox.com: game description, icon, 3-4 thumbnails, genre, and turn the game **Public** when they're ready. Then check Analytics (Retention, Funnels) after a few days; see `docs/GAME-TIPS.md` section 13.
