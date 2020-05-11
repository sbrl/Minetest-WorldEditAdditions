--- WorldEditAdditions-ChatCommands
-- @module worldeditadditions_commands
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions_commands = {}
local we_c = worldeditadditions_commands

we_c.modpath = minetest.get_modpath("worldeditadditions_commands")

dofile(we_c.modpath.."/utils/strings.lua")
dofile(we_c.modpath.."/utils/numbers.lua")

dofile(we_c.modpath.."/multi.lua")

-- We no longer need our own implementation of safe_region thanks to @sfan5's
-- suggestion in issue #5 - yay!
-- we_c.safe_region, we_c.check_region, we_c.reset_pending
--	= dofile(we_c.modpath.."/safe.lua")

dofile(we_c.modpath.."/commands/floodfill.lua")
dofile(we_c.modpath.."/commands/overlay.lua")
dofile(we_c.modpath.."/commands/ellipsoid.lua")
dofile(we_c.modpath.."/commands/torus.lua")
dofile(we_c.modpath.."/commands/maze.lua")

-- Don't registry the //bonemeal command if the bonemeal mod isn't present
if minetest.get_modpath("bonemeal") then
	dofile(we_c.modpath.."/commands/bonemeal.lua")
else
	minetest.log("action", "[WorldEditAdditions] bonemeal mod not detected: //bonemeal command not registered")
end
