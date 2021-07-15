--- WorldEditAdditions-Core
-- @module worldeditadditions_core
-- @release 1.13
-- @copyright 2021 Starbeamrainbowlabs and VorTechnix
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs and VorTechnix

worldeditadditions_core = {}
local we_c = worldeditadditions_core

we_c.modpath = minetest.get_modpath("worldeditadditions_core")

-- Initialise WorldEdit stuff if the WorldEdit mod is not present
if not minetest.get_modpath("worldedit") then
	dofile(we_c.modpath.."/worldedit/init.lua")
end

dofile(we_c.modpath.."/register/init.lua")
