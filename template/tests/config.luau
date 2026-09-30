--[[
	Checks for src/ReplicatedStorage/Shared/Config.lua, run outside Studio with Lune:

		lune run tests/config

	Catches mistakes in the game's numbers (a negative price, an Id used twice...) before anyone plays.
	Added something to Config? Add a check for it here with check(name, ok, detail).
]]

local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")

local source = fs.readFile("src/ReplicatedStorage/Shared/Config.lua")
local Config = luau.load(source, { debugName = "Config" })()

local failures, passes = {}, 0
local function check(name, ok, detail)
	if ok then
		passes += 1
	else
		table.insert(failures, name .. (detail ~= nil and (" (" .. tostring(detail) .. ")") or ""))
	end
end

-- Saving
check("DataStoreName is set", type(Config.DataStoreName) == "string" and #Config.DataStoreName > 0)
check("autosave is between 30 s and 5 min", Config.AutosaveSeconds >= 30 and Config.AutosaveSeconds <= 300, Config.AutosaveSeconds)

-- Coins on the map
check("a coin is worth something", Config.Coin.Value > 0, Config.Coin.Value)
check("coins on the map are capped (lag)", Config.Coin.MaxOnMap > 0 and Config.Coin.MaxOnMap <= 200, Config.Coin.MaxOnMap)
check("coins spawn at a sane speed", Config.Coin.SpawnEverySeconds >= 0.1, Config.Coin.SpawnEverySeconds)

-- Upgrades
local seen = {}
for _, upgrade in ipairs(Config.Upgrades) do
	local id = tostring(upgrade.Id)
	check("upgrade Id used once: " .. id, not seen[id])
	seen[id] = true
	check(id .. " has a name and description", type(upgrade.Name) == "string" and type(upgrade.Description) == "string")
	check(id .. " has a max level", upgrade.MaxLevel and upgrade.MaxLevel >= 1, upgrade.MaxLevel)
	check(id .. " costs grow each level", upgrade.CostGrowth and upgrade.CostGrowth > 1, upgrade.CostGrowth)
	local last = 0
	for level = 0, upgrade.MaxLevel - 1 do
		local cost = Config.UpgradeCost(id, level)
		check(id .. " level " .. level .. " has a positive price", cost and cost > 0, cost)
		check(id .. " level " .. level .. " costs more than the one before", cost and cost > last, cost)
		last = cost or last
	end
	check(id .. " is MAX at its max level", Config.UpgradeCost(id, upgrade.MaxLevel) == nil)
end
check("walk speed stays under 100 at max", Config.WalkSpeed({ WalkSpeed = Config.UpgradeById.WalkSpeed.MaxLevel }) < 100)

print(("%d passed, %d failed"):format(passes, #failures))
for _, failure in ipairs(failures) do
	print("  FAIL: " .. failure)
end
if #failures > 0 then
	process.exit(1)
end
