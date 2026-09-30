---
name: teamup
description: Set up a friend to work on this Roblox game together with the dev (Team Create in Studio, and GitHub if the friend has Claude too). Use when they type /teamup or say they're making the game with a friend / partner / "add my friend".
---

# /teamup: make the game a two-person game

Two ways a partner can help. Ask which one (AskUserQuestion): **"Does your friend have a Claude Pro subscription?"** (Yes / No / Not sure → treat as No for now; switching later is easy.)

## Everyone: share the Studio game (Team Create)
The dev (the game's owner) does this in Studio, one step at a time:
1. They must be **friends on Roblox** with the partner first.
2. Studio, with the game open: the **Collaborate** button (top right), or Home > Game Settings > Permissions. Add the friend with **Edit** access.
3. The partner opens Studio > **Shared with me** / Collaborations tab > the game. Both of you now see each other's changes live.
4. Tell the dev: only the owner's computer presses **Connect** in the Rojo plugin (Rojo allows one connection per game). The partner never presses Connect.

## Partner WITHOUT Claude
Give the dev `docs/PARTNER.md` to send to the friend (or read it with them). The short version:
- They build freely in Studio: the map, models, UI, effects, and they playtest.
- Scripts whose first line says `-- 📁 File script` belong to the files: the partner doesn't edit those (their edits get overwritten); they tell the dev what should change, and the dev's Claude does it.
- They CAN make brand-new scripts in Studio. The dev's Claude copies them into the files with `/grab` so they're saved in git. After that they're file scripts too.
- Run `/grab` at the start of each session and whenever the dev says "my friend made a script".

## Partner WITH Claude
1. Make sure this game is on GitHub (`git remote -v`; if not: `gh repo create <name> --private --source . --push`).
2. Ask for the friend's **GitHub username** (they make a free account at github.com/signup).
3. Invite them: `gh api -X PUT repos/<owner>/<repo>/collaborators/<friend> -f permission=push`. They must accept the invite (email or github.com/notifications).
4. The friend gets the Starter Kit folder too, double-clicks `1-SETUP.bat`, then `3-JOIN-A-FRIENDS-GAME.bat` and types `<owner>/<repo>`. Tell the dev the exact name to send.
5. In `CLAUDE.md`, fill in the "Working together" section: names, who is the Rojo holder (the owner).
6. From now on, at the start of every session on the owner's computer, run `scripts/watch-pull.ps1` in the background: it pulls the partner's pushes every 30 s, and Rojo puts them into the shared Studio game.

Commit + push the CLAUDE.md change. Tell the dev what's done and exactly what their friend has to do next.
