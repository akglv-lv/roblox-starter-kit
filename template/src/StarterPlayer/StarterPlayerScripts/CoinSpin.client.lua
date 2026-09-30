-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
--[[
	CoinSpin: makes every coin on the map spin and bob.

	Anything that moves on screen updates every frame (RenderStepped), on the player's own device.
	That way it looks smooth at any frame rate, and the server doesn't waste time on looks.
]]

local RunService = game:GetService("RunService")

local folder = workspace:WaitForChild("Coins")
local baseCFrame = {} -- [coin] = where the server put it

folder.ChildAdded:Connect(function(coin)
	baseCFrame[coin] = coin.CFrame
end)
folder.ChildRemoved:Connect(function(coin)
	baseCFrame[coin] = nil
end)
for _, coin in ipairs(folder:GetChildren()) do
	baseCFrame[coin] = coin.CFrame
end

RunService.RenderStepped:Connect(function()
	local t = os.clock()
	for coin, base in pairs(baseCFrame) do
		coin.CFrame = CFrame.new(base.Position + Vector3.new(0, math.sin(t * 3) * 0.4, 0)) * CFrame.Angles(0, t * 2, math.rad(90))
	end
end)
