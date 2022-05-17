--- WorldEditAdditions-Core
-- @module worldeditadditions_core
-- @release 1.13
-- @copyright 2021 Starbeamrainbowlabs and VorTechnix
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs and VorTechnix

local temp = true
if temp then return end
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
	register_command = dofile(modpath.."/core/register_command.lua")
}


local we_c = worldeditadditions_core

-- Initialise WorldEdit stuff if the WorldEdit mod is not present
if minetest.global_exists("bonemeal") then
	dofile(we_c.modpath.."/core/integrations/worldedit.lua")
else
	dofile(we_c.modpath.."/core/integrations/noworldedit.lua")
end
