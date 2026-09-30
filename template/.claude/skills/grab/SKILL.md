---
name: grab
description: Copy scripts a partner (or the dev) made by hand inside Roblox Studio into the game's files, so they're saved in git and kept in sync. Use when they type /grab, say "my friend made a script", or at the start of a session when a partner without Claude works on the game.
---

# /grab: bring Studio-made scripts into the files

Rojo keeps files → Studio in sync, but scripts someone creates by hand in Studio only live in the place. This finds them and saves them as files.

1. Studio MCP, play stopped. List every Script / LocalScript / ModuleScript under `ServerScriptService`, `StarterPlayer.StarterPlayerScripts` and `ReplicatedStorage.Shared`.
2. A script is **new from Studio** if there is no matching file in `src/` (same path, same name, same type). File scripts start with the line `-- 📁 File script`; Studio-made ones usually don't.
3. For each new one: write it to the matching path in `src/` (Script → `.server.lua`, LocalScript → `.client.lua`, ModuleScript → `.lua`; scripts with script children → a folder with `init.*.lua`). Copy the Source exactly and add the header line at the top:
   `-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).`
   Rojo will then match the file to the existing Studio script (same name and type) instead of making a copy. Check in Studio that there's only one of it.
4. A file script that someone **edited in Studio** (its Source differs from the file, and the file hasn't changed in git since): ask the dev which version to keep before overwriting anything. Never silently throw away someone's work.
5. Scripts inside models, parts or UI (Workspace, StarterGui) stay in Studio: leave them, just mention them.
6. Tidy only what's needed: `stylua`, `selene` (fix errors only), `lune run tests/config`. Don't change what the scripts do.
7. Commit ("Grab <names> from Studio (made by <who>)") and push. Tell the dev which scripts were saved, in one short list.
