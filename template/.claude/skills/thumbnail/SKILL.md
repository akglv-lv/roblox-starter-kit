---
name: thumbnail
description: Make a game icon (512x512) and thumbnails (1920x1080) for the dev's Roblox game, from a scene staged in Studio plus big readable text. Use when they type /thumbnail or ask for an icon, thumbnail, cover, banner or "pictures for my game page".
---

# /thumbnail: icon and thumbnails that make people click

Style (from `docs/GAME-TIPS.md` section 12): **bright and simple**. Blue sky, the game's main thing BIG in the middle, a happy Roblox avatar reacting, ONE huge readable word or number. Must still read when tiny (150 px on a phone). Clean beats busy: no clutter, no extra effects piled on.

## 1. Plan (don't ask much)
Read `docs/MY-GAME.md`. Propose 3 ideas in one short list (one line each: what's in it + the text), e.g. "Avatar holding a golden pet, text: 1,000,000 COINS!". Let them pick, or pick the best one yourself if they say "you choose". Make ONE image first, get a yes, then the rest.

## 2. Stage in Studio (play stopped, Edit mode)
- Build the scene in a Model `Workspace.__ThumbStage`, far away (e.g. 3000 studs up) so the real map is untouched: a simple ground, the game's hero objects (copies, not the originals), and the dev's avatar posed: `Players:CreateHumanoidModelFromUserId(<their UserId>)` (ask their Roblox username once and look up the id with the browser or `Players:GetUserIdFromNameAsync`), anchor its parts, turn it to face the camera.
- Lighting: if the look needs changing, **write down every Lighting / Sky / Atmosphere property you change and put them all back afterwards**. Never leave the game's lighting changed.
- Point `workspace.CurrentCamera` at the scene (`CameraType = Scriptable`, a nice angle slightly from below makes things look big). Keep a clear area for the text.

## 3. Capture
- Use the Studio MCP `screen_capture` to look at it and adjust until it looks great.
- To get a real image file: make Studio's window big (maximised), hide the UI/selection boxes, then save a picture of the viewport. Options, try in order: an image-saving tool the Studio MCP offers; a PowerShell screenshot of the Studio window region (`System.Drawing` `CopyFromScreen`) cropped to the 3D view; last resort, ask the dev to press **Win + Shift + S**, drag over the 3D view, and paste the file path for you.
- Save raw shots in `design/raw/` (add `design/raw/` to `.gitignore`).

## 4. Add the text (HTML → PNG, no extra installs)
- Write a small HTML page in `design/` with the shot as the background (`object-fit: cover`) and the text on top: a chunky Google Font (Luckiest Guy, Lilita One or Fredoka), white or yellow fill, thick dark outline (`-webkit-text-stroke` + a text-shadow), slight tilt is OK. One line, two at most. Text never covers the avatar's face or the hero object.
- Render it with Microsoft Edge (already on every Windows PC), headless:
  `& "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --headless --disable-gpu --hide-scrollbars --window-size=1920,1080 --screenshot="<out>.png" "file:///<page>.html"`
  (icon: `--window-size=512,512`). If Edge is elsewhere, find `msedge.exe` first.
- Sizes: thumbnails **1920×1080**, icon **512×512** (icon: no small text; just the hero + maybe one short word).

## 5. Review, clean up, hand over
- Look at every image yourself (Read the PNG). Check: sharp, bright, text readable when imagined tiny, no Studio UI, no selection boxes, no name tags.
- Delete `Workspace.__ThumbStage`, restore the camera and any lighting you changed. Check with the MCP that nothing of the stage is left.
- Keep finals in `design/thumbnails/`, commit + push. Send them the files and say where to upload: **create.roblox.com > Creations > the game > Places > (the place) > Thumbnails / Icon**. Suggest uploading 3–4 thumbnails so Roblox can test which gets more clicks.
