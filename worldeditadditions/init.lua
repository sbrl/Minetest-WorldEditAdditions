--- WorldEditAdditions
-- @module worldeditadditions
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions = {}
local wea = worldeditadditions
wea.modpath = minetest.get_modpath("worldeditadditions")

wea.Set = dofile(wea.modpath.."/utils/set.lua")

wea.Vector3 = dofile(wea.modpath.."/utils/vector3.lua")
wea.Mesh, wea.Face = dofile(wea.modpath.."/utils/mesh.lua")

wea.Queue = dofile(wea.modpath.."/utils/queue.lua")
wea.LRU = dofile(wea.modpath.."/utils/lru.lua")
wea.inspect = dofile(wea.modpath.."/utils/inspect.lua")

-- I/O compatibility layer
wea.io = dofile(wea.modpath.."/utils/io.lua")

wea.bit = dofile(wea.modpath.."/utils/bit.lua")

wea.terrain = dofile(wea.modpath.."/utils/terrain/init.lua")

dofile(wea.modpath.."/utils/vector.lua")
dofile(wea.modpath.."/utils/strings/init.lua")
dofile(wea.modpath.."/utils/format/init.lua")
dofile(wea.modpath.."/utils/parse/init.lua")
dofile(wea.modpath.."/utils/tables/init.lua")

dofile(wea.modpath.."/utils/numbers.lua")
dofile(wea.modpath.."/utils/nodes.lua")
dofile(wea.modpath.."/utils/node_identification.lua")

dofile(wea.modpath.."/utils/raycast_adv.lua") -- For the farwand
dofile(wea.modpath.."/utils/player.lua") -- Player info functions

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
dofile(wea.modpath.."/lib/conv/conv.lua")
dofile(wea.modpath.."/lib/erode/erode.lua")
dofile(wea.modpath.."/lib/noise/init.lua")
wea.sculpt = dofile(wea.modpath.."/lib/sculpt/init.lua")

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
