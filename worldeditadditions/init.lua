--- WorldEditAdditions
-- @module worldeditadditions
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions = {}
local wea = worldeditadditions
wea.modpath = minetest.get_modpath("worldeditadditions")

wea.Vector3 = dofile(wea.modpath.."/utils/vector3.lua")
wea.Mesh, wea.Face = dofile(wea.modpath.."/utils/mesh.lua")

wea.Queue = dofile(wea.modpath.."/utils/queue.lua")
wea.LRU = dofile(wea.modpath.."/utils/lru.lua")
wea.inspect = dofile(wea.modpath.."/utils/inspect.lua")

wea.bit = dofile(wea.modpath.."/utils/bit.lua")


dofile(wea.modpath.."/utils/vector.lua")
dofile(wea.modpath.."/utils/strings/init.lua")
dofile(wea.modpath.."/utils/format/init.lua")
dofile(wea.modpath.."/utils/parse/init.lua")
dofile(wea.modpath.."/utils/tables/init.lua")

dofile(wea.modpath.."/utils/numbers.lua")
dofile(wea.modpath.."/utils/nodes.lua")
dofile(wea.modpath.."/utils/node_identification.lua")
dofile(wea.modpath.."/utils/terrain.lua")
dofile(wea.modpath.."/utils/raycast_adv.lua") -- For the farwand
dofile(wea.modpath.."/utils/axes.lua")

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
dofile(wea.modpath.."/lib/conv/conv.lua")
dofile(wea.modpath.."/lib/erode/erode.lua")
dofile(wea.modpath.."/lib/noise/init.lua")

dofile(wea.modpath.."/lib/copy.lua")

dofile(wea.modpath.."/lib/count.lua")

dofile(wea.modpath.."/lib/bonemeal.lua")
dofile(wea.modpath.."/lib/forest.lua")

dofile(wea.modpath.."/lib/ellipsoidapply.lua")
dofile(wea.modpath.."/lib/airapply.lua")
dofile(wea.modpath.."/lib/noiseapply2d.lua")

dofile(wea.modpath.."/lib/subdivide.lua")
dofile(wea.modpath.."/lib/selection/stack.lua")
dofile(wea.modpath.."/lib/selection/cloud.lua")
