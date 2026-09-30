# Claude: set up this PC for making Roblox games (you do the work)

The person you're talking to is **new to this**. Their sibling set this kit up so that **you do everything**.
They should never need to open a terminal, read a script, or understand git.

Rules while doing this:
- Plain, short, friendly sentences. No jargon. No walls of text.
- Do every step you can yourself (use the **PowerShell** tool; this is Windows).
- For things only they can do (click in Studio, sign up on a website, type a code in the browser), give **one** clear instruction at a time and wait until they say "done".
- Ask questions with the AskUserQuestion tool when there are simple choices.
- If something fails, fix it yourself or try another way before asking them. Stay calm and encouraging.
- Don't explain every step. At most one short line of what you're doing ("Installing the tools… ✅").

The kit folder is where this file is (call it `KIT`). All scripts are in `KIT\scripts`.

**Ask as little as possible.** Every question and every "click this" is work for them. Collect everything you need in ONE round of questions at the start, then run the whole setup without stopping unless something truly needs their hands. Never ask "shall I continue?" or "is that OK?"; just continue.

## 1. Say hi, ask everything at once (one message)
Tell them: "I'll set everything up for you. It takes about 15 minutes, and I'll only ask you to click a few things."
Then, right away and only once: "**Tip:** so I don't keep asking permission for every step, click the mode button under the message box and choose **Auto** (or, when a permission box pops up, choose the 'always allow' option)."
Then ask everything in ONE AskUserQuestion / message:
- Their **name or nickname** (labels their saved versions).
- The **email** of their GitHub account, or "no account yet".
- Is their game **brand-new** or **already started** in Roblox Studio? And its **name**.
If they have no GitHub account: "Go to https://github.com/signup and make one (free), then tell me the email you used." That's the only thing to wait for here.

## 2. Check the apps they need
- **Roblox Studio**: check for `RobloxStudioBeta.exe` under `%LOCALAPPDATA%\Roblox\Versions`. If missing: "Go to https://create.roblox.com, click Start Creating, install Roblox Studio and sign in. Tell me when it's open." Wait.

## 3. Install everything else
Run (can take a few minutes; winget may show Windows "allow" prompts: tell them to click **Yes**):
```
powershell -NoProfile -ExecutionPolicy Bypass -File "KIT\scripts\setup.ps1" -GitName "<name>" -GitEmail "<email>" -NoLogin
```
Read the summary. For any FAIL, fix it (a new PowerShell may be needed for PATH; `$env:Path` can be refreshed from the User+Machine PATH) and re-run. The only expected WARNs now are "GitHub login" and possibly "Studio <-> Claude".

## 4. GitHub login
Run `gh auth login -h github.com -w -p https -s repo,workflow` **in the background** and read its output for the one-time code (like `ABCD-1234`). If gh isn't found, use `C:\Program Files\GitHub CLI\gh.exe`. Open https://github.com/login/device for them (`Start-Process`). Tell them:
"A GitHub page just opened. Type this code: **ABCD-1234**, then click Authorize." Wait for "done", then check `gh auth status`.

## 5. Let me see Roblox Studio
If `%LOCALAPPDATA%\Roblox\mcp.bat` already exists, the switch is already on: skip to re-running setup silently. Otherwise tell them, one step: "In Roblox Studio, click **Assistant** in the top bar, then the **gear** ⚙️ in that panel, and turn **ON** the switch called **MCP server**. Tell me when it's on."
Then check `%LOCALAPPDATA%\Roblox\mcp.bat` exists and re-run the setup script from step 3 (it registers Studio with the Claude app). If the switch has moved in a newer Studio, help them find it (search Studio's settings for "MCP").

## 6. Make their game folder
Use the answers from step 1 (don't ask again). Run:
```
powershell -NoProfile -ExecutionPolicy Bypass -File "KIT\scripts\new-game.ps1" -Name "<game name>" -Mode <1 for new, 2 for already started>
```
It makes `Documents\RobloxGames\<name>`, saves it with git, and backs it up privately on their GitHub. Check it printed "Saved" and "Backed up". If the GitHub backup failed (e.g. the name is taken), create it yourself with `gh repo create <other-name> --private --source . --push` inside the game folder.

## 7. Hand over (the last thing they do)
The Claude app must restart to connect to Studio. Tell them exactly this, nicely formatted:

> All set up! 🎉 Three last clicks:
> 1. **Quit Claude completely**: right-click the Claude icon near the clock (bottom right) > **Quit**. Then open Claude again.
> 2. Go to the **Code** tab, choose the folder **Documents > RobloxGames > <game folder>**, and pick **Auto** mode.
> 3. Make sure Roblox Studio is open (with your game open, if you already started one), then type **/start**.
>
> From then on, just tell Claude what you want in your game, like `/idea pets that follow you`.
> Ideas for what to say are in **WHAT-TO-SAY.md** (in the Starter Kit folder).

Also open the game folder in Explorer for them (`Start-Process explorer.exe <folder>`).
