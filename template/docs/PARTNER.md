# Working on {{GAME_NAME}} as a partner (no Claude needed)

Hey! You're helping make this game. Your friend (the owner) uses Claude to write most of the code.
You work directly in Roblox Studio. Here's how to do that without anyone's work getting lost.

## Getting in
1. Be friends with the owner on Roblox. They add you as a collaborator with **Edit** access.
2. Open Roblox Studio > **Shared with me** (or the Collaborations tab) > open the game.
   Always open it from there, never from a file saved on your PC: only the shared version reaches your friend.
3. You'll see each other's changes live. That's Team Create.

## What you can do freely ✅
- Build the map: parts, models, terrain, lighting, sounds.
- Make and design UI (ScreenGuis) and effects.
- Playtest as much as you want (Play button).
- Make **brand-new scripts**. When you do, tell your friend "I made a script called ___", so their Claude saves it into the files (`/grab`).

## The one rule ⚠️
If a script's **first line** says:
```
-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
```
don't change it in Studio. Those scripts come from files on your friend's PC, and the next sync would overwrite your change. Instead, tell your friend what you want changed, like "make the jump higher" or "coins should be worth 5". Their Claude does it and you see it appear in Studio a few seconds later.

## Good habits
- Don't press **Connect** in the Rojo plugin. Only the owner's PC does that.
- Say in chat what you're working on, so you don't both change the same thing.
- Group your builds in a Model or Folder with a clear name (e.g. `Workspace > Lobby`).
- Anchor parts that shouldn't move, and don't copy thousands of parts: lag hurts phone players.
- Ideas? Tell your friend. They go into `IDEAS.md` and get built.

## Want your own Claude later?
With a Claude Pro subscription you can write code too. Get the Starter Kit folder from your friend, double-click `1-SETUP.bat`, then `3-JOIN-A-FRIENDS-GAME.bat`. Your friend's Claude sets up the rest (`/teamup`).
