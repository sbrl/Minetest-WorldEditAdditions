--- WorldEditAdditions-ChatCommands
-- @module worldeditadditions_commands
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions_commands = {}
local we_c = worldeditadditions_commands

we_c.modpath = minetest.get_modpath("worldeditadditions_commands")

dofile(we_c.modpath.."/multi.lua")

we_c.safe_region, we_c.check_region, we_c.reset_pending
	= dofile(we_c.modpath.."/safe.lua")

dofile(we_c.modpath.."/commands/floodfill.lua")
dofile(we_c.modpath.."/commands/overlay.lua")
dofile(we_c.modpath.."/commands/ellipsoid.lua")
dofile(we_c.modpath.."/commands/torus.lua")
dofile(we_c.modpath.."/commands/maze.lua")
