--- WorldEditAdditions-ChatCommands
-- @namespace worldeditadditions_commands
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions_commands = {}
local wea_cmd = worldeditadditions_commands

wea_cmd.modpath = minetest.get_modpath("worldeditadditions_commands")

dofile(wea_cmd.modpath.."/player_notify_suppress.lua")


dofile(wea_cmd.modpath.."/commands/convolve.lua")
dofile(wea_cmd.modpath.."/commands/ellipsoid.lua")
dofile(wea_cmd.modpath.."/commands/ellipsoid2.lua")
dofile(wea_cmd.modpath.."/commands/erode.lua")
dofile(wea_cmd.modpath.."/commands/fillcaves.lua")
dofile(wea_cmd.modpath.."/commands/floodfill.lua")
dofile(wea_cmd.modpath.."/commands/hollow.lua")
dofile(wea_cmd.modpath.."/commands/layers.lua")
dofile(wea_cmd.modpath.."/commands/line.lua")
dofile(wea_cmd.modpath.."/commands/maze.lua")
dofile(wea_cmd.modpath.."/commands/noise2d.lua")
dofile(wea_cmd.modpath.."/commands/overlay.lua")
dofile(wea_cmd.modpath.."/commands/replacemix.lua")
dofile(wea_cmd.modpath.."/commands/scale.lua")
dofile(wea_cmd.modpath.."/commands/torus.lua")
dofile(wea_cmd.modpath.."/commands/walls.lua")
dofile(wea_cmd.modpath.."/commands/spiral2.lua")
dofile(wea_cmd.modpath.."/commands/copy.lua")
dofile(wea_cmd.modpath.."/commands/move.lua")
dofile(wea_cmd.modpath.."/commands/dome.lua")
dofile(wea_cmd.modpath.."/commands/metaball.lua")
dofile(wea_cmd.modpath.."/commands/count.lua")
dofile(wea_cmd.modpath.."/commands/sculpt.lua")
dofile(wea_cmd.modpath.."/commands/spline.lua")
dofile(wea_cmd.modpath.."/commands/revolve.lua")

-- Meta Commands
dofile(wea_cmd.modpath.."/commands/meta/init.lua")

-- Selection Tools
dofile(wea_cmd.modpath.."/commands/selectors/init.lua")

-- Measure Tools
dofile(wea_cmd.modpath.."/commands/measure/init.lua")

-- Wireframe
dofile(wea_cmd.modpath.."/commands/wireframe/init.lua")

dofile(wea_cmd.modpath.."/commands/extra/saplingaliases.lua")
dofile(wea_cmd.modpath.."/commands/extra/basename.lua")
dofile(wea_cmd.modpath.."/commands/extra/sculptlist.lua")

-- Don't register the //bonemeal command if the bonemeal mod isn't present
if minetest.global_exists("bonemeal") then
	dofile(wea_cmd.modpath.."/commands/bonemeal.lua")
	dofile(wea_cmd.modpath.."/commands/forest.lua")
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


dofile(wea_cmd.modpath.."/aliases.lua")
