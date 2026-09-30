-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
--[[
	GameClient  (StarterPlayer > StarterPlayerScripts > GameClient)

	Runs on each player's own device and draws their screen.
	This file only sets things up and shares helpers. Each menu lives in its own file in
	the Panels folder, as `return function(App) ... end`, and is switched on at the bottom.
	(Keeping menus in separate files stops this one from growing too big: Luau allows
	at most 200 local variables in one script.)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local player = Players.LocalPlayer

local App = {}
App.Config = Config
App.player = player
App.state = { Coins = 0, TotalCoins = 0, Upgrades = {} } -- what the server last told us we own

-- Colours used by every menu, so the whole game matches
App.C = {
	Panel = Color3.fromRGB(30, 32, 44),
	Row = Color3.fromRGB(45, 48, 64),
	Button = Color3.fromRGB(70, 160, 255),
	Good = Color3.fromRGB(80, 200, 110),
	Bad = Color3.fromRGB(230, 80, 80),
	Gold = Color3.fromRGB(255, 205, 40),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(180, 185, 200),
}

App.gui = Instance.new("ScreenGui")
App.gui.Name = "GameUI"
App.gui.ResetOnSpawn = false
App.gui.IgnoreGuiInset = true
App.gui.Parent = player:WaitForChild("PlayerGui")

---------------------------------------------------------------------------
-- Helpers every panel can use
---------------------------------------------------------------------------
local function round(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 12)
	corner.Parent = instance
end

function App.label(parent, text, size)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.FredokaOne
	l.TextColor3 = App.C.Text
	l.TextScaled = true
	l.Text = text or ""
	l.Size = size or UDim2.fromScale(1, 1)
	l.Parent = parent
	return l
end

function App.button(parent, text, color, onClick)
	local b = Instance.new("TextButton")
	b.AutoButtonColor = true
	b.BackgroundColor3 = color or App.C.Button
	b.Font = Enum.Font.FredokaOne
	b.TextColor3 = App.C.Text
	b.TextScaled = true
	b.Text = text
	round(b, 10)
	b.Parent = parent
	if onClick then
		b.Activated:Connect(onClick)
	end
	return b
end

-- A centred window with a title and a close button. Returns (window, contentArea).
function App.makePanel(title)
	local window = Instance.new("Frame")
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Position = UDim2.fromScale(0.5, 0.5)
	window.Size = UDim2.fromScale(0.4, 0.6)
	window.BackgroundColor3 = App.C.Panel
	window.Visible = false
	round(window, 16)
	local ratio = Instance.new("UISizeConstraint") -- keeps it readable on phones and big monitors
	ratio.MinSize = Vector2.new(300, 300)
	ratio.MaxSize = Vector2.new(520, 560)
	ratio.Parent = window
	window.Parent = App.gui

	local header = App.label(window, title, UDim2.new(1, -70, 0, 44))
	header.Position = UDim2.fromOffset(16, 8)
	header.TextXAlignment = Enum.TextXAlignment.Left

	local close = App.button(window, "X", App.C.Bad, function()
		window.Visible = false
	end)
	close.Size = UDim2.fromOffset(40, 40)
	close.Position = UDim2.new(1, -52, 0, 10)

	local content = Instance.new("ScrollingFrame")
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Position = UDim2.fromOffset(12, 60)
	content.Size = UDim2.new(1, -24, 1, -72)
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.CanvasSize = UDim2.new()
	content.ScrollBarThickness = 6
	content.Parent = window
	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 8)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = content

	return window, content
end

-- One row inside a panel's content area
function App.makeRow(parent, height)
	local row = Instance.new("Frame")
	row.BackgroundColor3 = App.C.Row
	row.Size = UDim2.new(1, -8, 0, height or 64)
	round(row, 10)
	row.Parent = parent
	return row
end

-- A small message that slides in at the top of the screen and fades away
function App.toast(text)
	local t = App.label(App.gui, text, UDim2.new(0.5, 0, 0, 40))
	t.AnchorPoint = Vector2.new(0.5, 0)
	t.Position = UDim2.new(0.5, 0, 0, -50)
	t.BackgroundTransparency = 0.2
	t.BackgroundColor3 = App.C.Panel
	round(t, 10)
	local constraint = Instance.new("UISizeConstraint")
	constraint.MaxSize = Vector2.new(460, 40)
	constraint.Parent = t
	TweenService:Create(t, TweenInfo.new(0.25), { Position = UDim2.new(0.5, 0, 0, 70) }):Play()
	task.delay(2.5, function()
		local fade = TweenService:Create(t, TweenInfo.new(0.4), { TextTransparency = 1, BackgroundTransparency = 1 })
		fade:Play()
		fade.Completed:Wait()
		t:Destroy()
	end)
end

-- Panels call App.onState(fn) to redraw whenever the server sends new numbers
local listeners = {}
function App.onState(fn)
	table.insert(listeners, fn)
	fn(App.state)
end

function App.fire(remoteName, ...)
	remotes:WaitForChild(remoteName):FireServer(...)
end

remotes:WaitForChild("State").OnClientEvent:Connect(function(state)
	App.state = state
	for _, fn in ipairs(listeners) do
		task.spawn(fn, state)
	end
end)
remotes:WaitForChild("Notify").OnClientEvent:Connect(App.toast)

---------------------------------------------------------------------------
-- Menus (one line each). New menu? Make Panels/<Name>.lua and add a line here.
---------------------------------------------------------------------------
require(script.Panels.Hud)(App)
require(script.Panels.Upgrades)(App)

App.fire("Ready") -- ask the server for our numbers now that every menu is listening
