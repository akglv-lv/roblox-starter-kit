---
name: idea
description: Add something the dev wants to their Roblox game. Use when they type /idea, or say "I want…", "add…", "can you make…", "make it so…". Turns a plain idea into a small plan, builds it, playtests it and saves it.
---

# /idea: turn what they want into a working feature

The dev describes something in their own words (it may be vague: "pets", "make it scarier", "a shop"). Your job: understand it, build it well, show them it works.

## 1. Understand (keep it quick and friendly)
- Repeat the idea back in one sentence: "So you want …".
- If it's unclear, ask **at most 3 short questions**, using the AskUserQuestion tool with 2 to 4 simple options each (they can also type their own answer). Good questions are about what the player SEES and DOES, not code:
  - "How does a player get it?" (buy with coins / find on the map / win it / free)
  - "What does it do?"
  - "Where on screen / on the map should it be?"
- If the idea is big (a whole new world, trading, a battle system), split it into small steps and build the first step only. Put the rest in `IDEAS.md` as "next steps".
- If the idea would hurt the game (lag, save loss, pop-up spam, cheating, Roblox rules; see `docs/GAME-TIPS.md`), say why in one sentence and offer a better version.

## 2. Show the plan (short)
A list of 3 to 6 bullet points in plain words, like:
- "A Pets button on the left that opens a pet menu"
- "Pets cost 100 coins and follow you around"
- "Each pet gives +10% coins"
Then say "Building it now!" and go. Only wait for a yes if the idea changed a lot from what they said, or it replaces something they already have.

## 3. Build it (the project way, from CLAUDE.md)
- Numbers first: prices, rewards, lists go in `Config.lua`, with a check in `tests/config.luau`.
- Saved stuff goes in `defaultData()` in `DataManager.lua`.
- Server logic in `GameServer.server.lua` or a new server module; the server checks everything the client asks.
- Menus as a new `Panels/<Name>.lua` plus one `require` line.
- Map stuff (parts, models) through the Studio MCP tools, anchored, tidy, grouped in a named Model/Folder.
- Follow `docs/GAME-TIPS.md`: phone-sized buttons, motion every frame on the client, no pop-up stacking, cap anything that spawns.

## 4. Check and test
- `stylua src tests`, `selene src --allow-warnings` (0 errors), `lune run tests/config` (0 failed).
- Playtest in Studio as a fresh player (`/test` steps): no red errors in the Output, the feature works, take a screenshot and look at it.
- Fix anything broken before telling them it's done.

## 5. Save and tell them
- Commit (clear message) and push.
- Tell them: what you added (2 to 4 bullets), **what to try in-game** ("Press Play, grab 100 coins, click Pets"), and **one thing they learned** (one sentence on how it works).
- Mark it done in `IDEAS.md`, and suggest one small next step that would make it better.
