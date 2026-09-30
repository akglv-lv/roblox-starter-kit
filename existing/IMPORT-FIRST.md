# ⚠️ Claude: this game already exists in Studio. Import its scripts BEFORE Rojo connects.

This folder was made for a game the dev (and maybe a partner) already started in Roblox Studio.
Its scripts only live inside the Studio place right now. `/start` must copy them into `src/` first,
so git has them and Rojo keeps them in sync. Follow these steps, then delete this file.

1. Do NOT start `rojo serve` / Connect yet.
2. With the Studio MCP (play stopped), list every Script, LocalScript and ModuleScript in:
   - `ServerScriptService` (everything below it)
   - `StarterPlayer.StarterPlayerScripts` (everything below it)
   - `ReplicatedStorage` (only a folder named `Shared` is synced; see step 4)
3. Write each one into the matching folder under `src/`, keeping the same names and nesting:
   - Script → `Name.server.lua`, LocalScript → `Name.client.lua`, ModuleScript → `Name.lua`
   - A script with other scripts inside it → a folder `Name/` with `init.server.lua` / `init.client.lua` / `init.lua` plus the children
   - A Folder → a folder
   - Copy the Source exactly (use script_read), then put this line at the very top:
     `-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).`
   - A script that is Disabled in Studio: import it and note it in `IDEAS.md` ("disabled in Studio: check if still needed"), because Rojo will switch it on.
   - Two siblings with the same name: rename one in Studio first (ask the dev), since files can't share a name.
   - Things that aren't scripts (RemoteEvents, values, models) stay in Studio; the project is set to leave unknown things alone.
4. ModuleScripts in `ReplicatedStorage` that aren't in a `Shared` folder: leave them in Studio for now and tell the dev. Moving them into `Shared` would change their `require` paths; do that later as its own step, fixing every `require`.
5. Scripts inside models, parts or UI in Workspace / StarterGui stay where they are (they belong to that object). Edit those through the MCP directly, carefully, and tell the dev.
6. Run `stylua src tests`, `selene src --allow-warnings` (fix errors only, never change behaviour), `rojo build -o build.rbxl` (then delete it). Commit: "Bring the existing scripts into files".
7. Now start `rojo serve` and have the dev press Plugins > Rojo > Connect. Rojo matches the files to the scripts that already exist (same name + type), so nothing is duplicated. Check in Studio that each script appears once, and playtest: the game must work exactly as before.
8. Delete this file, commit, push, and continue `/start` at Part C (plan the game) if `docs/MY-GAME.md` doesn't exist yet.
