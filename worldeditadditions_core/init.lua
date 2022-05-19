--- WorldEditAdditions-Core
-- @module worldeditadditions_core
-- @release 1.13
-- @copyright 2021 Starbeamrainbowlabs and VorTechnix
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs and VorTechnix

-- local temp = true
-- if temp then return end
-- This mod isn't finished yet, so it will not be executed for now.


local modpath = minetest.get_modpath("worldeditadditions_core")

worldeditadditions_core = {
	modpath = modpath,
	registered_commands = {},
	-- Storage for per-player node limits before safe_region kicks in.
	-- TODO: Persist these to disk.
	safe_region_limits = {},
	-- The default limit for new players on the number of potential nodes changed before safe_region kicks in.
	safe_region_limit_default = 100000,
}

local wea_c = worldeditadditions_core
wea_c.register_command = dofile(modpath.."/core/register_command.lua")
wea_c.fetch_command_def = dofile(modpath.."/core/fetch_command_def.lua")


-- Initialise WorldEdit stuff if the WorldEdit mod is not present
if minetest.global_exists("worldedit") then
	dofile(wea_c.modpath.."/core/integrations/worldedit.lua")
else
	dofile(wea_c.modpath.."/core/integrations/noworldedit.lua")
end
