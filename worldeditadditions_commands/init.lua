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

-- We no longer need our own implementation of safe_region thanks to @sfan5's
-- suggestion in issue #5 - yay!
-- we_c.safe_region, we_c.check_region, we_c.reset_pending
--	= dofile(we_c.modpath.."/safe.lua")

dofile(we_c.modpath.."/commands/floodfill.lua")
dofile(we_c.modpath.."/commands/overlay.lua")
dofile(we_c.modpath.."/commands/layers.lua")
dofile(we_c.modpath.."/commands/ellipsoid.lua")
dofile(we_c.modpath.."/commands/torus.lua")
dofile(we_c.modpath.."/commands/walls.lua")
dofile(we_c.modpath.."/commands/maze.lua")
dofile(we_c.modpath.."/commands/replacemix.lua")
dofile(we_c.modpath.."/commands/convolve.lua")

dofile(we_c.modpath.."/commands/count.lua")

dofile(we_c.modpath.."/commands/subdivide.lua")

-- Don't registry the //bonemeal command if the bonemeal mod isn't present
if minetest.get_modpath("bonemeal") then
	dofile(we_c.modpath.."/commands/bonemeal.lua")
else
	minetest.log("action", "[WorldEditAdditions] bonemeal mod not detected: //bonemeal command not registered (if you see this message and you're using an alternative mod that provides bonemeal, please get in touch by opening an issue)")
end


worldedit.alias_command("smoothadv", "convolve")
worldedit.alias_command("conv", "convolve")

worldedit.alias_command("naturalise", "layers")
worldedit.alias_command("naturalize", "layers")

worldedit.alias_command("flora", "bonemeal")
