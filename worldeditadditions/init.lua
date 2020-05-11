--- WorldEditAdditions
-- @module worldeditadditions
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions = {}

dofile(minetest.get_modpath("worldeditadditions") .. "/utils.lua")
dofile(minetest.get_modpath("worldeditadditions") .. "/lib/floodfill.lua")
dofile(minetest.get_modpath("worldeditadditions") .. "/lib/overlay.lua")
dofile(minetest.get_modpath("worldeditadditions") .. "/lib/ellipsoid.lua")
dofile(minetest.get_modpath("worldeditadditions") .. "/lib/torus.lua")
dofile(minetest.get_modpath("worldeditadditions") .. "/lib/maze2d.lua")
dofile(minetest.get_modpath("worldeditadditions") .. "/lib/maze3d.lua")

dofile(minetest.get_modpath("worldeditadditions") .. "/lib/walls.lua")

dofile(minetest.get_modpath("worldeditadditions") .. "/lib/bonemeal.lua")
