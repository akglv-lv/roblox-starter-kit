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

check("the game has a name", type(Config.GameName) == "string" and #Config.GameName > 0)

print(("%d passed, %d failed"):format(passes, #failures))
for _, failure in ipairs(failures) do
	print("  FAIL: " .. failure)
end
if #failures > 0 then
	process.exit(1)
end
