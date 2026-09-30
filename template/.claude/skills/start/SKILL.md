---
name: start
description: First-time setup of this game with the dev, then plan their game together. Use on the very first session, or when they type /start, or say "set up my game" / "let's start".
---

# /start: get everything working, then plan the game

Go one step at a time. Do everything you can yourself; for each thing only they can do, give ONE instruction and wait.

## Part A: make sure the tools work
1. Check the tools: `rojo --version`, `selene --version`, `stylua --version`, `lune --version`, `git --version`, `gh auth status`. If something is missing, run `rokit install` in this folder; if that fails, tell them to double-click `1-SETUP.bat` in the Starter Kit folder again.
2. Check you can see Roblox Studio (the Roblox_Studio MCP tools, e.g. get_studio_state). If not, walk them through:
   - Open Roblox Studio and sign in.
   - Open the **Assistant** panel (top bar), click the **gear**, turn on **MCP server**.
   - Double-click `1-SETUP.bat` again, then quit and reopen the Claude app, and type `/start` again.

## Part B: make the place and connect it
**If `IMPORT-FIRST.md` exists, the game already exists in Studio:** skip steps 3 and 6. Ask them to open the game in Studio (from Roblox, not a file), try step 4 (API access, optional: never block on it), then follow `IMPORT-FIRST.md` completely (it includes connecting Rojo). Then go to Part C.

3. Ask them to make the place: in Studio, **New > Baseplate**. Then **File > Publish to Roblox**, create a new game, and give it their game's name. (Publishing once is needed so saving works.)
4. **Optional, never block on it:** saving during Studio playtests needs API access. Tell them: **File > Game Settings** (older Studio: the Game Settings button on the Home tab) **> Security > Enable Studio Access to API Services > Save**. If it's greyed out or they can't find it: the game must be published first (File > Publish to Roblox), and only the game's **owner** can change it (if a friend created the game, the friend flips it). If they're stuck for more than a minute, say "No problem, we'll skip it for now" and carry on; remind them in one line at the end. Everything else works without it.
5. Check `%LOCALAPPDATA%\Roblox\Plugins\RojoManagedPlugin.rbxm` exists; if not, run `rojo plugin install`, confirm the file appeared, and tell them to close and reopen Studio (plugins only load when Studio starts). Start `rojo serve` in the background here. Ask them: **Plugins tab > Rojo > Connect**. Still no Rojo button: check Plugins > Manage Plugins (it may be switched off). Check with the MCP that `ServerScriptService.GameServer` exists.
6. Set the Workspace attribute `StudioFreshSave = true`, start a playtest, confirm coins spawn, the coin counter and Upgrades menu show, and the Output has no red errors. Stop play. Tell them to press **Play** themselves and walk into a coin. 🎉 "Your game works! Everything from here is your ideas."

## Part C: plan their game (the fun part)
7. Ask them to describe their dream game in their own words ("what do players do?"). Then ask a few quick questions with AskUserQuestion, one at a time, simple options:
   - What do players do most of the time? (collect / fight / build / explore / race / survive / something else)
   - What do they collect or earn?
   - What do they spend it on?
   - What's the big goal that takes a long time?
   - What makes it look cool / different from other games?
8. Write `docs/MY-GAME.md`: the game in one sentence, the core loop ("do X → earn Y → buy Z → do X faster"), the first 5 minutes of a new player (see `docs/GAME-TIPS.md` section 1), and the long-term goal.
9. Write `IDEAS.md` as a short checklist in build order, core loop first, then the first 5 minutes, then everything else (daily rewards, events, Robux items last).
10. Ask: "Are you making this with a friend?" If yes, run `/teamup` now.
11. Commit and push. Tell them: "Your plan is saved. Type `/idea` and the first item, or just tell me what you want to build first."
12. Suggest replacing the coin demo with their core loop as the first `/idea`.
