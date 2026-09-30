# Game tips: how to make a Roblox game that runs well and that people keep playing

These are lessons learned the hard way on a real, published Roblox game with real players.
Claude: follow these on every feature. Explain the relevant one to the player-dev in one plain sentence when it changes what you build.

---

## 1. The first 5 minutes decide everything
Most players who leave, leave in the first **45 seconds** or between **2 and 4 minutes**. Real numbers from a launched game: of 65 new players, only half did the main thing once, and under a third were still there at 5 minutes.
- **Fun in the first 10 seconds.** A new player should be doing the core thing (collecting, fighting, opening, building) almost right away. No long intro, no wall of text.
- **One pop-up at a time.** The biggest quitting moments lined up exactly with pop-ups stacked on each other (tip + reward window + shop offer all at once). Queue pop-ups; never show two together; show nothing extra for the first minutes except the next goal.
- **Always show the next goal.** A small bar or line at the top: "Collect 10 coins", "Buy your first upgrade". Players who don't know what to do next leave.
- **Hide what they can't use yet.** Don't show 10 buttons with red "!" badges on the first screen. Unlock buttons as they become useful, with a short "New!" moment.
- **No jargon.** "Pity meter", "multiplier stacking", "rebirth tokens" mean nothing to a new kid. Say what it does: "Your next rare is closer".
- **Never pop a Robux offer in the first minutes.** It makes the game feel like a trap. Let them enjoy it first.

## 2. Build for phones first
Most Roblox players are on phones.
- Buttons at least **44 pixels** tall, so thumbs can hit them.
- Test in Studio's **Device Emulator** (Test tab > Device) as a phone in landscape. Text must not overlap or run off the edge.
- Use `UISizeConstraint` / scale sizes so menus fit small and big screens (the starter panels already do this).
- Keep the middle of the screen clear: that's where the game happens.

## 3. Make it run smoothly (performance)
- **Anything that moves on screen updates every frame** with `RunService.RenderStepped`, on the client (see `CoinSpin.client.lua`). Never move things inside a `while task.wait(0.1)` loop: it looks choppy on fast screens and wastes the server's time.
- **Timers are for game logic only** (spawning, saving, checking), never for motion.
- **Limit how many things exist.** Always cap spawns (like `Config.Coin.MaxOnMap`). Thousands of parts = lag on phones.
- **Anchor parts that don't need physics.** Unanchored parts cost physics time.
- **Turn off `CanTouch` / `CanQuery` / `CastShadow`** on decoration parts that don't need them.
- **Clean up.** When you create connections for a thing that gets destroyed, disconnect them or destroy the instance so they go with it. Leaks slowly lag long servers.
- **Don't fire remotes every frame.** Send changes when something changes, not constantly.
- **Emoji:** Roblox's font can't draw some newer emoji (🪨 🪵 🛖 and similar show as boxes). Test any unusual emoji in-game before using it.

## 4. Never lose a player's save
Losing progress is the fastest way to get bad reviews.
- All saving goes through `DataManager.lua`. It already retries, saves when players leave, when the server shuts down, and every 60 seconds.
- **If loading fails, never hand out a blank save** (it would overwrite the real one when saved). DataManager already kicks with a "please rejoin" message instead.
- **Add new saved stuff to `defaultData()`** so old saves get it automatically.
- **Never rename `Config.DataStoreName`** unless you want every player to start over.
- In Studio, turn on **Game Settings > Security > Enable Studio Access to API Services**, or nothing saves while testing.
- To test as a brand-new player without wiping your real save: set the attribute `StudioFreshSave = true` on **Workspace** (in Edit mode).

## 5. Stop cheaters: the server decides
- Players can change anything on their own device (their scripts, their UI, what they send).
- So the **client only ASKS** ("I want to buy upgrade X"), and the **server checks** (does it exist? can they afford it? are they close enough? is it too soon?) before doing it. See `BuyUpgrade` in `GameServer.server.lua`.
- Never let the client say how many coins to give, how much damage it did, or what it won.
- Add cooldowns to anything a player can spam.

## 6. Keep all numbers in one place
- Every price, reward, speed, timer and list lives in `src/ReplicatedStorage/Shared/Config.lua`. Balancing the game then means editing one file.
- Every time something new goes in Config, add a check for it in `tests/config.luau` (a price that's negative or an Id that's used twice is caught before anyone plays).

## 7. Pacing: the game must not run out, and must not be too slow
- Decide your pace on purpose: e.g. "first upgrade in 30 seconds, first big unlock around 10 minutes, the main goal takes days".
- Every new reward, boost or bonus speeds everything up. Before adding one, ask: "does this make the game end too fast?"
- Costs usually grow by about ×1.3 to ×2 per level (see `CostGrowth`). Rewards grow slower than costs, so there's always a next goal.
- Give players something to spend on at every stage. A currency piling up with nothing to buy is boring.

## 8. Reasons to come back tomorrow
Add these once the core game is fun, not before:
- Daily reward with a streak.
- Timed events (a special thing every 30 minutes on every server).
- Something to show off: a leaderboard, a rare item other players can see, a title.
- Short-term goals (daily quests) on top of the long-term goal.
- Collection: "12 / 40 found" makes people want to finish.

## 9. Robux (making money) without being annoying
- Game passes = bought once, forever (2x coins, VIP). Developer products = bought again and again (a pack of coins, a boost).
- **Always give the item in `ProcessReceipt` and save the receipt id** so a purchase is never given twice or lost.
- The best offers show up **when they're useful** (out of coins right before an upgrade), not randomly.
- Fair and fun beats pay-to-win: players who feel tricked leave, and they don't buy.
- A starter pack (cheap, one time, great value) is the classic first purchase.

## 10. Roblox rules to never break
- **Never reward likes, favourites or follows.** It's against Roblox rules and can get the game taken down.
- No real-money gambling feel for things bought with Robux: if something random is bought with Robux, show the odds.
- Text players type must go through Roblox's filtering (`TextService`) before other players see it.
- Don't use other people's copyrighted characters, music or logos.

## 11. Looks: clean beats busy
- "Make it look cooler" means **polish** (nice colours, lighting, shine, clear text, smooth animation), not piling on more stuff.
- Readable text first. One big idea per screen.
- Keep one colour set for the whole UI (`App.C`), so every menu matches.
- Don't make the lighting too bright; softer lighting usually looks better.

## 12. Thumbnails and icon (what makes people click)
- Bright and simple: blue sky, a happy Roblox avatar, the main thing of your game BIG in the middle.
- One huge readable word or number (like "1,000,000 COINS!"). Very little clutter.
- Must still be readable when tiny (like on a phone's home page).
- Upload 3 or 4 thumbnails so Roblox can test which one gets more clicks.

## 13. After you publish: read the numbers
Creator Dashboard (create.roblox.com) > your game > **Analytics**:
- **Retention:** how many come back the next day. Aim for about 20% before spending Robux on ads.
- **Funnels:** add funnel steps in code with `AnalyticsService:LogOnboardingFunnelStepEvent` (step 1 = joined, 2 = did the main thing, 3 = bought first upgrade...). The biggest drop between steps is the thing to fix first.
- **Session length:** how long people play. Watch it go up after each fix.
- Fix the biggest drop first, change one thing, then check again a few days later.

## 14. Working habits
- **Small steps.** Add one thing, playtest it, save it (git), then the next.
- **Playtest after every change.** Play it like a brand-new player would.
- **Ask someone else to play** and watch them without helping. Where they get stuck is what to fix.
- Keep a list of ideas in `IDEAS.md`, and build the ones that make the first 5 minutes more fun first.
