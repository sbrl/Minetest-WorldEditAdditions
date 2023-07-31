--- WorldEditAdditions
-- @namespace worldeditadditions
-- @release 1.14.5
-- @copyright 2023 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions = {}
local wea = worldeditadditions
wea.modpath = minetest.get_modpath("worldeditadditions")

dofile(wea.modpath.."/lib/compat/saplingnames.lua")

dofile(wea.modpath.."/lib/floodfill.lua")
dofile(wea.modpath.."/lib/overlay.lua")
dofile(wea.modpath.."/lib/layers.lua")
dofile(wea.modpath.."/lib/fillcaves.lua")
dofile(wea.modpath.."/lib/ellipsoid.lua")
dofile(wea.modpath.."/lib/ellipsoid2.lua")
dofile(wea.modpath.."/lib/torus.lua")
dofile(wea.modpath.."/lib/line.lua")
dofile(wea.modpath.."/lib/walls.lua")
dofile(wea.modpath.."/lib/replacemix.lua")
dofile(wea.modpath.."/lib/maze2d.lua")
dofile(wea.modpath.."/lib/maze3d.lua")
dofile(wea.modpath.."/lib/hollow.lua")
dofile(wea.modpath.."/lib/scale_up.lua")
dofile(wea.modpath.."/lib/scale_down.lua")
dofile(wea.modpath.."/lib/scale.lua")
dofile(wea.modpath.."/lib/spiral_square.lua")
dofile(wea.modpath.."/lib/spiral_circle.lua")
dofile(wea.modpath.."/lib/dome.lua")
dofile(wea.modpath.."/lib/spline.lua")
dofile(wea.modpath.."/lib/revolve.lua")
dofile(wea.modpath.."/lib/conv/conv.lua")
dofile(wea.modpath.."/lib/erode/erode.lua")
dofile(wea.modpath.."/lib/noise/init.lua")
wea.sculpt		= dofile(wea.modpath.."/lib/sculpt/init.lua")
wea.metaballs	= dofile(wea.modpath.."/lib/metaballs/init.lua")

dofile(wea.modpath.."/lib/copy.lua")
dofile(wea.modpath.."/lib/move.lua")

dofile(wea.modpath.."/lib/count.lua")

dofile(wea.modpath.."/lib/bonemeal.lua")
dofile(wea.modpath.."/lib/forest.lua")

dofile(wea.modpath.."/lib/ellipsoidapply.lua")
dofile(wea.modpath.."/lib/airapply.lua")
dofile(wea.modpath.."/lib/noiseapply2d.lua")

dofile(wea.modpath.."/lib/subdivide.lua")

dofile(wea.modpath.."/lib/selection/init.lua") -- Helpers for selections

dofile(wea.modpath.."/lib/wireframe/corner_set.lua")
dofile(wea.modpath.."/lib/wireframe/make_compass.lua")
dofile(wea.modpath.."/lib/wireframe/wire_box.lua")



---
-- Post-setup tasks
---

--- 1: Scan for an import static brushes
-- Static brushes live in lib/sculpt/brushes (relative to this file), and have
-- the file extension ".brush.tsv" (without quotes, of course).
wea.sculpt.scan_static(wea.modpath.."/lib/sculpt/brushes")
