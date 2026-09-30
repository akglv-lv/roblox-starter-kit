---
name: launch-ready
description: Make the dev's Roblox game safe for real players before it goes public - switch saving to ProfileStore (session-locked, the standard for big games), check purchases, remotes, text filtering, phones and analytics. Use when they type /launch-ready, or say they want to make the game public / launch it / get real players. Run it once before the first public launch (then /ship for each update).
---

# /launch-ready: before real players join

Do it all yourself, one area at a time, testing after each. Tell the dev in plain words what each part protects ("so nobody loses their stuff if Roblox hiccups").
If they're about to launch, do this before `/ship`.

## 1. Saving: switch to ProfileStore
Why: the simple saver works for testing, but with real players two servers can load the same save at once (they rejoin fast, a server lags) and one overwrites the other. ProfileStore (by loleris, used by huge games) locks each save to one server and autosaves safely.

1. Download it (free, Apache 2.0 licence; keep its header comment):
   `https://raw.githubusercontent.com/MadStudioRoblox/ProfileStore/main/ProfileStore.luau` → `src/ServerScriptService/ProfileStore.lua`. Don't reformat or lint-fix it: add `src/ServerScriptService/ProfileStore.lua` to the ignore lists (a `.styluaignore` line, and run selene with it excluded or accept its warnings; errors in it must be 0).
2. Rewrite the inside of the game's save module (in the kit: `DataManager.lua`) **keeping the same functions** (`Load`, `Get`, `Save`, `Release`) so nothing else changes:
   - `local store = ProfileStore.New(Config.DataStoreName .. "_PS", defaultData())` (a NEW store name; see step 3). In Studio with `StudioFreshSave` on, use `store.Mock`.
   - `Load(player)`: `store:StartSessionAsync("p_" .. player.UserId, { Cancel = function() return player.Parent ~= Players end })`. nil → return `nil, "failed"` (GameServer kicks with "please rejoin"). Otherwise `profile:AddUserId(player.UserId)`, `profile:Reconcile()`, `profile.OnSessionEnd:Connect(function() profiles[player] = nil; player:Kick("Your data was loaded on another server. Please rejoin.") end)`; if the player left meanwhile, `profile:EndSession()`. Return `profile.Data, "ok"`.
   - `Get(player)` returns `profile.Data`. `Save(player)`: `profile:Save()` (ProfileStore also autosaves by itself). `Release(player)`: `profile:EndSession()`.
   - Remove the old autosave loop and BindToClose saving: ProfileStore does both.
3. **Keep existing players' progress.** If the game was already played with the old saver, add a one-time copy: in `defaultData()` add `Migrated = false`; after loading, if `not data.Migrated`, read the OLD key with plain `DataStoreService:GetDataStore(Config.DataStoreName):GetAsync("p_" .. userId)`; if it's a table, copy its fields into `profile.Data`; then set `data.Migrated = true`. Never delete the old store.
4. If the game (e.g. one imported from Studio) has its own saving code instead of the kit's DataManager: read it fully first, explain to the dev what you'll change, and apply the same idea (ProfileStore underneath, same functions on top, one-time copy of old saves).
5. Test: fresh save in Studio (Mock), then a real Studio save (API access on): earn something, stop, play again, it's still there. Output has no ProfileStore errors.

## 2. Robux purchases
- Developer products are only granted inside `MarketplaceService.ProcessReceipt`, return `PurchaseGranted` only after the item is in the player's data, and remember `receipt.PurchaseId` in their save so it's never given twice.
- Game passes are checked with `UserOwnsGamePassAsync` on join (pcall) and on `PromptGamePassPurchaseFinished`.
- No `Id = 0` left for anything meant to be sold. Show odds for anything random bought with Robux.

## 3. Cheating and spam
- Every RemoteEvent handler checks its arguments' types and that the action is allowed (price, distance, cooldown). Add a small per-player cooldown to anything spammable.
- Test/dev chat commands only work in Studio or for the owner.

## 4. Roblox rules
- Any text one player types that others see goes through `TextService:FilterStringAsync` first.
- Nothing rewards likes, favourites or follows.
- Experience Questionnaire on the Creator Dashboard filled in honestly (it sets the age rating).

## 5. Phones and first 5 minutes
- `/test` in the Device Emulator (phone, landscape): buttons ≥ 44 px, nothing overlapping, the first 5 minutes are clear (`docs/GAME-TIPS.md` sections 1 and 2).

## 6. Know what players do (analytics)
- Add onboarding funnel steps with `AnalyticsService:LogOnboardingFunnelStepEvent(player, step, "name")` at the key first-time moments (1 joined, 2 did the main thing once, 3 first upgrade, ...), each only once per player (remember it in their save). Tell the dev where to read them: Creator Dashboard > Analytics > Funnels.

## 7. Wrap up
Checks + commit + push. Give the dev a short "ready ✅ / still to do" list, then suggest `/thumbnail` (if they have no icon/thumbnails yet) and `/ship`.
