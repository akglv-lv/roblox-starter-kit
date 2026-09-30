-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
--[[
	DataManager  (ServerScriptService > DataManager)

	Loads and saves each player's progress with DataStoreService.
	In Studio: Home > Game Settings > Security > turn on "Enable Studio Access to API Services",
	or saving is skipped (the game still works, it just forgets you when you stop).

	Adding something new to save? Add it to defaultData() below. Old saves get it filled in
	automatically the next time they load (see reconcile).
]]

local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local DataManager = {}

local profiles = {} -- [player] = their data table
local canSave = {} -- [player] = true if their data really came from the DataStore

local store
local ok, err = pcall(function()
	store = DataStoreService:GetDataStore(Config.DataStoreName)
end)
if not ok then
	warn("[DataManager] DataStore unavailable:", err)
end

local function defaultData()
	return {
		Coins = Config.StartingCoins,
		TotalCoins = 0, -- all coins ever earned
		Upgrades = {}, -- ["CoinValue"] = 3
		LastOnline = os.time(),
	}
end

-- Fill in fields that were added to the game after this save was made
local function reconcile(data)
	for key, value in pairs(defaultData()) do
		if data[key] == nil then
			data[key] = value
		end
	end
	return data
end

-- Roblox's save servers sometimes hiccup, so try up to 3 times (once in Studio, so tests stay fast)
local function retry(callback)
	local attempts = RunService:IsStudio() and 1 or 3
	local lastError
	for attempt = 1, attempts do
		local success, result = pcall(callback)
		if success then
			return true, result
		end
		lastError = result
		warn("[DataManager] attempt " .. attempt .. " failed:", result)
		if attempt < attempts then
			task.wait(attempt * 2)
		end
	end
	return false, lastError
end

-- Studio test switch: put the attribute StudioFreshSave = true on Workspace and every Studio playtest
-- starts as a brand-new player on a save that is never written. Ignored in the real game.
local function freshSaveMode()
	return RunService:IsStudio() and workspace:GetAttribute("StudioFreshSave") == true
end

-- Returns (data, status). status is "ok", "nosave" (a test save that won't be written) or "failed"
function DataManager.Load(player)
	if freshSaveMode() or not store then
		profiles[player] = defaultData()
		canSave[player] = false
		return profiles[player], "nosave"
	end

	local success, result = retry(function()
		return store:GetAsync("p_" .. player.UserId)
	end)
	if not success then
		if RunService:IsStudio() then
			profiles[player] = defaultData()
			canSave[player] = false
			return profiles[player], "nosave"
		end
		-- never hand out a blank save when loading failed: saving it would wipe their real progress
		return nil, "failed"
	end

	local data = reconcile(type(result) == "table" and result or defaultData())
	profiles[player] = data
	canSave[player] = true
	return data, "ok"
end

function DataManager.Get(player)
	return profiles[player]
end

-- Returns true if the save worked
function DataManager.Save(player)
	local data = profiles[player]
	if not data or not canSave[player] then
		return false
	end
	data.LastOnline = os.time()
	return (retry(function()
		store:UpdateAsync("p_" .. player.UserId, function()
			return data
		end)
	end))
end

function DataManager.Release(player)
	profiles[player] = nil
	canSave[player] = nil
end

return DataManager
