--- A wrapper to simultaniously handle global and world settings.

-- Initialize settings container
local weac = worldeditadditions_core
weac.settings = {}

-- Initialize wea world folder if not already existing
local path = minetest.get_worldpath() .. "/worldeditadditions"
minetest.mkdir(path)

-- @class
local setting_handler = {}

--- Reads world settings into WEA core settings object
setting_handler.read = function()
	local file, err = io.open(path .. "/settings.conf", "rb")
	if err then return false end
	-- Split by newline
	local settings = wea_c.split(file.read(),"[\n\r]+")
end

--- Write setting to world settings
setting_handler.write = function(setting, state)
	local writer, err = io.open(path .. "/settings.conf", "ab")
	if not writer then
		return false
	elseif setting == "" and not state then
		writer:write("")
	else
		writer:write("worldeditadditions_" .. setting .. " = " .. state .. "\n")
	end
	writer:flush()
	writer:close()
	return true
end

-- Test for world settings and generate file if none
if not setting_handler.read() then
	setting_handler.write("")
end

return setting_handler