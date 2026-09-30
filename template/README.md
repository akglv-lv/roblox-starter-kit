# {{GAME_NAME}}

My Roblox game. Scripts live in `src/` and go into Studio through Rojo.

**How to work on it:** open this folder in the Claude app (Code tab) and just tell Claude what you want.
- `/start`: first time only (setup + plan the game)
- `/idea <what you want>`: add something
- `/fix <what's wrong>`: fix a bug
- `/test`: playtest it
- `/ship`: get ready to publish

| Folder | What's in it |
|---|---|
| `src/ServerScriptService` | Server scripts: saving, rewards, shops (players can't cheat these) |
| `src/ReplicatedStorage/Shared/Config.lua` | Every number in the game |
| `src/StarterPlayer/StarterPlayerScripts` | What runs on each player's screen (menus, effects) |
| `tests/` | Automatic checks of the numbers |
| `docs/GAME-TIPS.md` | How to make the game fun, fast and safe |
| `docs/MY-GAME.md` | The plan for this game |
| `IDEAS.md` | The to-do list |
