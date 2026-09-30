---
name: test
description: Playtest the dev's Roblox game in Studio like a brand-new player and report what works and what doesn't. Use when they type /test or ask "does it work?" / "test it".
---

# /test: play it like a new player

1. Make sure Studio has the latest code (Rojo connected, play stopped). Set the Workspace attribute `StudioFreshSave = true` so this run is a brand-new player and the real save is untouched.
2. Start play. Read the Output: any red error is a bug to fix.
3. Walk through the first 5 minutes as a new player would (see `docs/MY-GAME.md` and `docs/GAME-TIPS.md` section 1). Take screenshots at key moments and actually look at them: is it clear what to do? Anything overlapping, off-screen, or too small?
4. Check the phone view too when UI changed: Studio's Device Emulator, a phone in landscape. Buttons at least 44 px, nothing overlapping.
5. Stop play. Report in 3 short lists: ✅ works, ❌ broken (fix these right away if small, ask if big), 💡 ideas that would make the first minutes more fun (just suggestions).
