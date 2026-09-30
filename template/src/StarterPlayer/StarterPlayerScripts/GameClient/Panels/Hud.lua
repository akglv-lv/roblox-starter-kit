-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
-- The coins counter at the top of the screen
return function(App)
	local box = Instance.new("Frame")
	box.AnchorPoint = Vector2.new(0.5, 0)
	box.Position = UDim2.new(0.5, 0, 0, 12)
	box.Size = UDim2.fromOffset(220, 50)
	box.BackgroundColor3 = App.C.Panel
	box.BackgroundTransparency = 0.15
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = box
	box.Parent = App.gui

	local text = App.label(box, "", UDim2.new(1, -20, 1, -10))
	text.Position = UDim2.fromOffset(10, 5)
	text.TextColor3 = App.C.Gold

	App.onState(function(state)
		text.Text = "🪙 " .. state.Coins .. " Coins"
	end)
end
