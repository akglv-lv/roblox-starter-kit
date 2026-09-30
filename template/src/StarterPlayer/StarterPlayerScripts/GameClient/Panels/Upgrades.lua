-- 📁 File script: change it through Claude (edits made inside Studio get overwritten).
-- The Upgrades button (left side) and the window it opens
return function(App)
	local Config = App.Config
	local window, content = App.makePanel("⬆️ Upgrades")

	local open = App.button(App.gui, "⬆️ Upgrades", App.C.Good, function()
		window.Visible = not window.Visible
	end)
	open.AnchorPoint = Vector2.new(0, 0.5)
	open.Position = UDim2.new(0, 12, 0.5, 0)
	open.Size = UDim2.fromOffset(150, 50)

	-- one row per upgrade in Config.Upgrades
	local rows = {}
	for order, upgrade in ipairs(Config.Upgrades) do
		local row = App.makeRow(content, 70)
		row.LayoutOrder = order

		local name = App.label(row, upgrade.Name, UDim2.new(0.6, -12, 0.5, -4))
		name.Position = UDim2.fromOffset(12, 6)
		name.TextXAlignment = Enum.TextXAlignment.Left

		local info = App.label(row, upgrade.Description, UDim2.new(0.6, -12, 0.4, -6))
		info.Position = UDim2.new(0, 12, 0.55, 0)
		info.TextXAlignment = Enum.TextXAlignment.Left
		info.TextColor3 = App.C.SubText

		local buy = App.button(row, "", App.C.Button, function()
			App.fire("BuyUpgrade", upgrade.Id) -- the server checks the price, not us
		end)
		buy.AnchorPoint = Vector2.new(1, 0.5)
		buy.Position = UDim2.new(1, -10, 0.5, 0)
		buy.Size = UDim2.new(0.38, 0, 0, 46)

		rows[upgrade.Id] = { buy = buy, info = info, description = upgrade.Description }
	end

	App.onState(function(state)
		for id, row in pairs(rows) do
			local level = state.Upgrades[id] or 0
			local cost = Config.UpgradeCost(id, level)
			row.info.Text = row.description .. "  (Lv " .. level .. ")"
			if cost then
				row.buy.Text = "🪙 " .. cost
				row.buy.BackgroundColor3 = state.Coins >= cost and App.C.Good or App.C.Row
			else
				row.buy.Text = "MAX"
				row.buy.BackgroundColor3 = App.C.Row
			end
		end
	end)
end
