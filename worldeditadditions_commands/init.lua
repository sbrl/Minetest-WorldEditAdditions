--- WorldEditAdditions-ChatCommands
-- @module worldeditadditions_commands
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions_commands = {}
local we_c = worldeditadditions_commands

we_c.modpath = minetest.get_modpath("worldeditadditions_commands")

dofile(we_c.modpath.."/player_notify_suppress.lua")



-- We no longer need our own implementation of safe_region thanks to @sfan5's
-- suggestion in issue #5 - yay!
-- we_c.safe_region, we_c.check_region, we_c.reset_pending
--	= dofile(we_c.modpath.."/safe.lua")

dofile(we_c.modpath.."/commands/convolve.lua")
dofile(we_c.modpath.."/commands/ellipsoid.lua")
dofile(we_c.modpath.."/commands/ellipsoid2.lua")
dofile(we_c.modpath.."/commands/erode.lua")
dofile(we_c.modpath.."/commands/fillcaves.lua")
dofile(we_c.modpath.."/commands/floodfill.lua")
dofile(we_c.modpath.."/commands/hollow.lua")
dofile(we_c.modpath.."/commands/layers.lua")
dofile(we_c.modpath.."/commands/line.lua")
dofile(we_c.modpath.."/commands/maze.lua")
dofile(we_c.modpath.."/commands/noise2d.lua")
dofile(we_c.modpath.."/commands/overlay.lua")
dofile(we_c.modpath.."/commands/replacemix.lua")
dofile(we_c.modpath.."/commands/scale.lua")
dofile(we_c.modpath.."/commands/torus.lua")
dofile(we_c.modpath.."/commands/walls.lua")
dofile(we_c.modpath.."/commands/spiral2.lua")
dofile(we_c.modpath.."/commands/copy.lua")
dofile(we_c.modpath.."/commands/move.lua")

dofile(we_c.modpath.."/commands/count.lua")
dofile(we_c.modpath.."/commands/sculpt.lua")

-- Meta Commands
dofile(we_c.modpath.."/commands/meta/init.lua")

-- Selection Tools
dofile(we_c.modpath.."/commands/selectors/init.lua")

-- Measure Tools
dofile(we_c.modpath.."/commands/measure/init.lua")

-- Wireframe
dofile(we_c.modpath.."/commands/wireframe/init.lua")

dofile(we_c.modpath.."/commands/extra/saplingaliases.lua")
dofile(we_c.modpath.."/commands/extra/basename.lua")
dofile(we_c.modpath.."/commands/extra/sculptlist.lua")

-- Don't register the //bonemeal command if the bonemeal mod isn't present
if minetest.global_exists("bonemeal") then
	dofile(we_c.modpath.."/commands/bonemeal.lua")
	dofile(we_c.modpath.."/commands/forest.lua")
else
	minetest.log("action", "[WorldEditAdditions] bonemeal mod not detected: //bonemeal and //forest commands not registered (if you see this message and you're using an alternative mod that provides bonemeal, please get in touch by opening an issue)")
end

-- Minetest doesn't allow you to read from files outside the mod
-- directory - even if you're part of a modpack you can't read from the main
-- modpack directory. Furthermore, symlinks don't help.
-- If you have a solution to this issue, please comment on this GitHub issue:
-- https://github.com/sbrl/Minetest-WorldEditAdditions/issues/55
-- NOTE TO SELF: When uncommenting this, also add "doc?" to depends.txt
-- if minetest.get_modpath("doc") then
-- 	dofile(we_c.modpath.."/doc/init.lua")
-- else
-- 	minetest.log("action", "[WorldEditAdditions] doc mod not detected: not registering doc category with extended help")
-- end


worldedit.alias_command("smoothadv", "convolve")
worldedit.alias_command("conv", "convolve")

worldedit.alias_command("naturalise", "layers")
worldedit.alias_command("naturalize", "layers")

worldedit.alias_command("flora", "bonemeal")

-- Measure Tools
worldedit.alias_command("mcount", "count")
worldedit.alias_command("mfacing", "mface")


--- Overrides to core WorldEdit commands
-- These are commented out for now, as they could be potentially dangerous to stability
-- Thorough testing is required of our replacement commands before these are uncommented
-- TODO: Depend on worldeditadditions_core before uncommenting this
-- BUG: //move+ seems to be leaving stuff behind for some strange reason --@sbrl 2021-12-26
-- worldeditadditions_core.alias_override("copy", "copy+")
-- worldeditadditions_core.alias_override("move", "move+") -- MAY have issues where it doesn't overwrite the old region properly, but haven't been able to reliably reproduce this
-- worldeditadditions_core.alias_override("replace", "replacemix")
