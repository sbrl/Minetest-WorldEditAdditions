--- WorldEditAdditions
-- @module worldeditadditions
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions = {}
worldeditadditions.modpath = minetest.get_modpath("worldeditadditions")
dofile(worldeditadditions.modpath.."/utils/strings.lua")
dofile(worldeditadditions.modpath.."/utils/numbers.lua")

dofile(worldeditadditions.modpath.."/utils.lua")
dofile(worldeditadditions.modpath.."/lib/floodfill.lua")
dofile(worldeditadditions.modpath.."/lib/overlay.lua")
dofile(worldeditadditions.modpath.."/lib/ellipsoid.lua")
dofile(worldeditadditions.modpath.."/lib/torus.lua")
dofile(worldeditadditions.modpath.."/lib/walls.lua")
dofile(worldeditadditions.modpath.."/lib/replacemix.lua")
dofile(worldeditadditions.modpath.."/lib/maze2d.lua")
dofile(worldeditadditions.modpath.."/lib/maze3d.lua")

dofile(worldeditadditions.modpath.."/lib/count.lua")

dofile(worldeditadditions.modpath.."/lib/bonemeal.lua")
