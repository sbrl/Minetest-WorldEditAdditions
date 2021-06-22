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
dofile(we_c.modpath.."/commands/erode.lua")
dofile(we_c.modpath.."/commands/fillcaves.lua")
dofile(we_c.modpath.."/commands/floodfill.lua")
dofile(we_c.modpath.."/commands/hollow.lua")
dofile(we_c.modpath.."/commands/layers.lua")
dofile(we_c.modpath.."/commands/line.lua")
dofile(we_c.modpath.."/commands/maze.lua")
dofile(we_c.modpath.."/commands/overlay.lua")
dofile(we_c.modpath.."/commands/replacemix.lua")
dofile(we_c.modpath.."/commands/scale.lua")
dofile(we_c.modpath.."/commands/torus.lua")
dofile(we_c.modpath.."/commands/walls.lua")

dofile(we_c.modpath.."/commands/count.lua")

dofile(we_c.modpath.."/commands/meta/multi.lua")
dofile(we_c.modpath.."/commands/meta/many.lua")
dofile(we_c.modpath.."/commands/meta/subdivide.lua")
dofile(we_c.modpath.."/commands/meta/ellipsoidapply.lua")

dofile(we_c.modpath.."/commands/selectors/srel.lua")
dofile(we_c.modpath.."/commands/selectors/scentre.lua")
dofile(we_c.modpath.."/commands/selectors/scloud.lua")
dofile(we_c.modpath.."/commands/selectors/scol.lua")
dofile(we_c.modpath.."/commands/selectors/scube.lua")
dofile(we_c.modpath.."/commands/selectors/smake.lua")
dofile(we_c.modpath.."/commands/selectors/spop.lua")
dofile(we_c.modpath.."/commands/selectors/spush.lua")
dofile(we_c.modpath.."/commands/selectors/srect.lua")
dofile(we_c.modpath.."/commands/selectors/sstack.lua")

dofile(we_c.modpath.."/commands/extra/saplingaliases.lua")
dofile(we_c.modpath.."/commands/extra/basename.lua")

-- Don't registry the //bonemeal command if the bonemeal mod isn't present
if minetest.get_modpath("bonemeal") then
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

worldedit.alias_command("mcount", "count")
