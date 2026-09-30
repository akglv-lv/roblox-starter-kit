-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
--[[
	Config  (ReplicatedStorage > Shared > Config)

	Every number in the game lives here: prices, rewards, speeds, upgrade lists.
	Want the game easier or harder? Change it here, never inside the other scripts.
	Both the server and the players' screens read this file, so they always agree.
]]

local Config = {}

Config.GameName = "{{GAME_NAME}}"

-- Where saves are kept. Changing this name gives EVERY player a fresh save, so only do it on purpose.
Config.DataStoreName = "PlayerData_v1"

Config.StartingCoins = 0
Config.AutosaveSeconds = 60 -- how often everyone's progress is saved while they play

-- The coins that pop up around the map
Config.Coin = {
	Value = 1, -- coins one coin is worth (before upgrades)
	SpawnEverySeconds = 1.5,
	MaxOnMap = 30,
	SpawnRadius = 60, -- studs from the middle of the map
}

-- Upgrades players can buy with coins. Add a new one by copying a line and giving it a new Id.
-- Cost of the next level = BaseCost * CostGrowth ^ (levels you already have)
Config.Upgrades = {
	{ Id = "CoinValue", Name = "Shinier Coins", Description = "+1 coins from every coin", BaseCost = 10, CostGrowth = 1.5, MaxLevel = 25 },
	{ Id = "WalkSpeed", Name = "Faster Shoes", Description = "+2 walk speed", BaseCost = 25, CostGrowth = 1.7, MaxLevel = 10 },
}

-- Quick lookup: Config.UpgradeById.CoinValue
Config.UpgradeById = {}
for _, upgrade in ipairs(Config.Upgrades) do
	Config.UpgradeById[upgrade.Id] = upgrade
end

-- Price of the next level, or nil when the upgrade is maxed
function Config.UpgradeCost(id, level)
	local upgrade = Config.UpgradeById[id]
	if not upgrade or level >= upgrade.MaxLevel then
		return nil
	end
	return math.floor(upgrade.BaseCost * upgrade.CostGrowth ^ level + 0.5)
end

-- What one coin is worth for a player with these upgrade levels
function Config.CoinValue(levels)
	return Config.Coin.Value + (levels.CoinValue or 0)
end

function Config.WalkSpeed(levels)
	return 16 + 2 * (levels.WalkSpeed or 0)
end

return Config
