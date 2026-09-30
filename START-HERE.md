# 🎮 Roblox Game Starter Kit

Make your own Roblox games with Claude doing the coding. You bring the ideas, Claude builds them,
and you learn how it all works along the way. About 30 minutes to set up, once.

---

## Step 1: Get the apps and accounts (10 min)
1. **Roblox Studio**: go to https://create.roblox.com, click **Start Creating**, install it, sign in with your Roblox account.
2. **Claude app**: go to https://claude.ai/download, install it, sign in with your Claude Pro account.
3. **GitHub account** (free, keeps a backup of every version of your game): https://github.com/signup

## Step 2: Set up your PC (10 min)
1. Double-click **`1-SETUP.bat`**.
   - It installs everything else by itself. If Windows asks "Do you want to allow…", click **Yes**.
   - It asks your name and your GitHub email. Type them and press Enter.
   - A browser page opens for GitHub: copy the code it showed in the black window, paste it in the page, click **Authorize**.
2. Open **Roblox Studio**. Top bar: open the **Assistant** panel, click the **gear** ⚙️, turn **ON** "MCP server". (This lets Claude see and control Studio.)
3. Double-click **`1-SETUP.bat`** again. Everything should be green `[OK]`. Anything yellow or red says how to fix it.
4. **Quit the Claude app fully** (right-click its icon near the clock > Quit) and open it again.

## Step 3: Make your game (5 min)
Double-click **`2-NEW-GAME.bat`**. Type your game's name, then pick:
- **1 = brand-new game.** You start from a tiny working example (coins + upgrades) that Claude swaps for your idea.
- **2 = a game you already started in Studio** (like the one you're making with Phil). Claude copies your existing scripts in first, so nothing is lost.

It makes your game folder in **Documents > RobloxGames**, saves it, and backs it up privately on GitHub.

## Step 4: Start building with Claude
1. Open **Roblox Studio** (for option 2: open your game there).
2. Open the **Claude app** > **Code** tab > choose your game's folder (Documents > RobloxGames > your game). Pick **Auto** mode.
3. Type **`/start`** and press Enter.

Claude checks everything, helps you connect Studio, then asks you about your dream game and writes a plan.
After that, just tell it what you want. **`WHAT-TO-SAY.md`** has examples.

---

## Making a game with a friend (like Phil) 👥
Type **`/teamup`** to Claude and answer its questions. It works both ways:
- **Friend without Claude:** they work in Studio on the same game (building the map, UI, models). Claude gives them a short guide (`docs/PARTNER.md` in your game folder).
- **Friend with Claude Pro:** they can code too. They get this kit, run `1-SETUP.bat`, then **`3-JOIN-A-FRIENDS-GAME.bat`**. Claude tells you what to send them.

Your PC is the "main" one: only yours presses **Connect** in Studio's Rojo plugin.

---

## Words you'll hear
| Word | What it means |
|---|---|
| **Script** | Code that makes things happen in the game |
| **Server** | Roblox's computer running the game. It decides everything, so players can't cheat |
| **Client** | Each player's own device. It draws the screen and menus |
| **Rojo** | Copies the scripts from your folder into Studio, live |
| **Git / GitHub** | Saves every version of your game, so you can always go back. GitHub is the online backup |
| **Commit / push** | "Save a version" / "back it up online". Claude does this for you |
| **Publish** | Sends your game to Roblox so people can play it |
| **Team Create** | Two people editing the same Studio game at once |

## Something's wrong?
| Problem | Fix |
|---|---|
| Claude says it can't see Studio | Studio must be open. Check the MCP server switch (Step 2.2), then quit and reopen the Claude app |
| "not recognized" errors | Close the window, double-click `1-SETUP.bat` again |
| Changes don't show up in Studio | Studio: Plugins > **Rojo** > **Connect** |
| Studio updated and Claude lost it | Quit and reopen the Claude app |
| Anything else | Tell Claude exactly what you see: `/fix` and describe it |
