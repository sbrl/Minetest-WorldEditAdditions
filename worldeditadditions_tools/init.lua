worldeditadditions_tools = {
	player_data = {},
	registered_tools = {},
}
local wea_t = worldeditadditions_tools

local modpath = minetest.get_modpath("worldeditadditions_tools")


-- Libraries
dofile(modpath.."/lib/do_raycast.lua")
dofile(modpath.."/lib/settings.lua")

wea_t.register_tool = dofile(modpath.."/lib/register_tool.lua")

-- Items
dofile(modpath.."/items/farwand.lua")
dofile(modpath.."/items/cloudwand.lua")
dofile(modpath.."/items/multiwand.lua")
dofile(modpath.."/items/movetool.lua")

-- Chat commands
dofile(modpath.."/commands/farwand_config.lua")
dofile(modpath.."/commands/weatool.lua")
