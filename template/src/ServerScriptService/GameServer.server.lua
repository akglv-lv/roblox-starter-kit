-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
--[[
	GameServer  (ServerScriptService > GameServer)

	The boss script. It runs on Roblox's server, never on a player's device, so players can't cheat it.
	It loads saves, gives coins, sells upgrades and tells each player's screen what they have.

	Golden rule: the server decides, the client only asks. A player's screen can ASK to buy an
	upgrade, but the server checks the price and their coins before saying yes.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared.Config)
local DataManager = require(script.Parent.DataManager)

---------------------------------------------------------------------------
-- Remotes: the "phone lines" between the server and each player's screen.
-- They are made here in code (not by hand in Studio) so they are saved in git too.
---------------------------------------------------------------------------
local remotes = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = ReplicatedStorage

local function remote(name)
	local r = remotes:FindFirstChild(name) or Instance.new("RemoteEvent")
	r.Name = name
	r.Parent = remotes
	return r
end

local StateRemote = remote("State") -- server -> client: "here is everything you own"
local NotifyRemote = remote("Notify") -- server -> client: a little message on screen
local ReadyRemote = remote("Ready") -- client -> server: "my screen is loaded, send me my stuff"
local BuyUpgradeRemote = remote("BuyUpgrade") -- client -> server: "I'd like to buy this upgrade"

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function sendState(player)
	local data = DataManager.Get(player)
	if not data then
		return
	end
	StateRemote:FireClient(player, {
		Coins = data.Coins,
		TotalCoins = data.TotalCoins,
		Upgrades = data.Upgrades,
	})
	local stats = player:FindFirstChild("leaderstats")
	if stats then
		stats.Coins.Value = data.Coins
	end
end

local function notify(player, text)
	NotifyRemote:FireClient(player, text)
end

local function addCoins(player, amount)
	local data = DataManager.Get(player)
	if not data then
		return
	end
	data.Coins += amount
	data.TotalCoins += amount
	sendState(player)
end

local function applyWalkSpeed(player)
	local data = DataManager.Get(player)
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if data and humanoid then
		humanoid.WalkSpeed = Config.WalkSpeed(data.Upgrades)
	end
end

---------------------------------------------------------------------------
-- Joining and leaving
---------------------------------------------------------------------------
local function onPlayerAdded(player)
	local data, status = DataManager.Load(player)
	if status == "failed" then
		player:Kick("Roblox couldn't load your save right now. Please rejoin in a minute!")
		return
	end
	if not player.Parent then
		return -- they left while the save was loading
	end

	-- leaderstats = the numbers shown on the player list (top right)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = data.Coins
	coins.Parent = stats
	stats.Parent = player

	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		applyWalkSpeed(player)
	end)
	applyWalkSpeed(player)
	sendState(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do -- anyone who joined before this script started
	task.spawn(onPlayerAdded, player)
end

Players.PlayerRemoving:Connect(function(player)
	DataManager.Save(player)
	DataManager.Release(player)
end)

-- When a server shuts down, save everyone at the same time before it closes
game:BindToClose(function()
	local left = 0
	for _, player in ipairs(Players:GetPlayers()) do
		left += 1
		task.spawn(function()
			DataManager.Save(player)
			left -= 1
		end)
	end
	local deadline = os.clock() + 25
	while left > 0 and os.clock() < deadline do
		task.wait(0.1)
	end
end)

-- Autosave, so a crash never loses more than a minute
task.spawn(function()
	while true do
		task.wait(Config.AutosaveSeconds)
		for _, player in ipairs(Players:GetPlayers()) do
			task.spawn(DataManager.Save, player)
		end
	end
end)

---------------------------------------------------------------------------
-- Requests from players' screens (never trust what they send: check everything)
---------------------------------------------------------------------------
ReadyRemote.OnServerEvent:Connect(function(player)
	sendState(player)
end)

BuyUpgradeRemote.OnServerEvent:Connect(function(player, id)
	local data = DataManager.Get(player)
	if not data or type(id) ~= "string" or not Config.UpgradeById[id] then
		return
	end
	local level = data.Upgrades[id] or 0
	local cost = Config.UpgradeCost(id, level)
	if not cost then
		notify(player, "That upgrade is maxed!")
		return
	end
	if data.Coins < cost then
		notify(player, "You need " .. (cost - data.Coins) .. " more Coins")
		return
	end
	data.Coins -= cost
	data.Upgrades[id] = level + 1
	applyWalkSpeed(player)
	sendState(player)
	notify(player, Config.UpgradeById[id].Name .. " is now level " .. (level + 1) .. "!")
end)

---------------------------------------------------------------------------
-- Coins that pop up on the map. The server makes them and pays out; each player's
-- own screen makes them spin (CoinSpin.client.lua), because motion belongs on the client.
---------------------------------------------------------------------------
local coinFolder = Instance.new("Folder")
coinFolder.Name = "Coins"
coinFolder.Parent = workspace

local random = Random.new()

local function spawnCoin()
	local r = Config.Coin.SpawnRadius
	local origin = Vector3.new(random:NextNumber(-r, r), 200, random:NextNumber(-r, r))
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = { coinFolder }
	params.FilterType = Enum.RaycastFilterType.Exclude
	local hit = workspace:Raycast(origin, Vector3.new(0, -400, 0), params)
	if not hit then
		return -- nothing under this spot (off the map), try again next time
	end

	local coin = Instance.new("Part")
	coin.Name = "Coin"
	coin.Shape = Enum.PartType.Cylinder
	coin.Size = Vector3.new(0.4, 2.5, 2.5)
	coin.Color = Color3.fromRGB(255, 205, 40)
	coin.Material = Enum.Material.Neon
	coin.Anchored = true
	coin.CanCollide = false
	coin.CFrame = CFrame.new(hit.Position + Vector3.new(0, 2.5, 0)) * CFrame.Angles(0, 0, math.rad(90))
	coin.Parent = coinFolder

	local taken = false
	coin.Touched:Connect(function(part)
		if taken then
			return
		end
		local player = Players:GetPlayerFromCharacter(part.Parent)
		local data = player and DataManager.Get(player)
		if data then
			taken = true
			coin:Destroy()
			addCoins(player, Config.CoinValue(data.Upgrades))
		end
	end)
end

task.spawn(function()
	while true do
		task.wait(Config.Coin.SpawnEverySeconds)
		if #coinFolder:GetChildren() < Config.Coin.MaxOnMap then
			spawnCoin()
		end
	end
end)

---------------------------------------------------------------------------
-- Test commands, only in Studio or for the game's owner: type in chat
--   /coins 500   gives you 500 coins
---------------------------------------------------------------------------
local function isOwner(player)
	return RunService:IsStudio() or (game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId)
end

local function hookCommands(player)
	player.Chatted:Connect(function(message)
		if not isOwner(player) then
			return
		end
		local amount = message:match("^/coins%s+(%d+)$")
		if amount then
			addCoins(player, tonumber(amount))
			notify(player, "Gave you " .. amount .. " Coins")
		end
	end)
end

Players.PlayerAdded:Connect(hookCommands)
for _, player in ipairs(Players:GetPlayers()) do
	hookCommands(player)
end
