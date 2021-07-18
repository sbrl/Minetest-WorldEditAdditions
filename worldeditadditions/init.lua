--- WorldEditAdditions
-- @module worldeditadditions
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

worldeditadditions = {}
worldeditadditions.modpath = minetest.get_modpath("worldeditadditions")
dofile(worldeditadditions.modpath.."/utils/vector.lua")
worldeditadditions.Set = dofile(worldeditadditions.modpath.."/utils/set.lua")
worldeditadditions.Vector3 = dofile(worldeditadditions.modpath.."/utils/vector3.lua")
worldeditadditions.Mesh,
worldeditadditions.Face = dofile(worldeditadditions.modpath.."/utils/mesh.lua")

worldeditadditions.Queue = dofile(worldeditadditions.modpath.."/utils/queue.lua")
worldeditadditions.LRU = dofile(worldeditadditions.modpath.."/utils/lru.lua")


dofile(worldeditadditions.modpath.."/utils/strings/init.lua")
dofile(worldeditadditions.modpath.."/utils/format/init.lua")
dofile(worldeditadditions.modpath.."/utils/parse/init.lua")
dofile(worldeditadditions.modpath.."/utils/tables/init.lua")

dofile(worldeditadditions.modpath.."/utils/numbers.lua")
dofile(worldeditadditions.modpath.."/utils/nodes.lua")
dofile(worldeditadditions.modpath.."/utils/node_identification.lua")
dofile(worldeditadditions.modpath.."/utils/terrain.lua")
dofile(worldeditadditions.modpath.."/utils/raycast_adv.lua") -- For the farwand
dofile(worldeditadditions.modpath.."/utils/axes.lua")

dofile(worldeditadditions.modpath.."/lib/compat/saplingnames.lua")

dofile(worldeditadditions.modpath.."/lib/floodfill.lua")
dofile(worldeditadditions.modpath.."/lib/overlay.lua")
dofile(worldeditadditions.modpath.."/lib/layers.lua")
dofile(worldeditadditions.modpath.."/lib/fillcaves.lua")
dofile(worldeditadditions.modpath.."/lib/ellipsoid.lua")
dofile(worldeditadditions.modpath.."/lib/torus.lua")
dofile(worldeditadditions.modpath.."/lib/line.lua")
dofile(worldeditadditions.modpath.."/lib/walls.lua")
dofile(worldeditadditions.modpath.."/lib/replacemix.lua")
dofile(worldeditadditions.modpath.."/lib/maze2d.lua")
dofile(worldeditadditions.modpath.."/lib/maze3d.lua")
dofile(worldeditadditions.modpath.."/lib/hollow.lua")
dofile(worldeditadditions.modpath.."/lib/scale_up.lua")
dofile(worldeditadditions.modpath.."/lib/scale_down.lua")
dofile(worldeditadditions.modpath.."/lib/scale.lua")
dofile(worldeditadditions.modpath.."/lib/conv/conv.lua")
dofile(worldeditadditions.modpath.."/lib/erode/erode.lua")
dofile(worldeditadditions.modpath.."/lib/noise/init.lua")

dofile(worldeditadditions.modpath.."/lib/count.lua")

dofile(worldeditadditions.modpath.."/lib/bonemeal.lua")
dofile(worldeditadditions.modpath.."/lib/forest.lua")

dofile(worldeditadditions.modpath.."/lib/ellipsoidapply.lua")
dofile(worldeditadditions.modpath.."/lib/airapply.lua")

dofile(worldeditadditions.modpath.."/lib/subdivide.lua")
dofile(worldeditadditions.modpath.."/lib/selection/stack.lua")
dofile(worldeditadditions.modpath.."/lib/selection/cloud.lua")
local wea = worldeditadditions
wea.modpath = minetest.get_modpath("worldeditadditions")

wea.Vector3 = dofile(wea.modpath.."/utils/vector3.lua")
wea.Mesh, wea.Face = dofile(wea.modpath.."/utils/mesh.lua")

wea.Queue = dofile(wea.modpath.."/utils/queue.lua")
wea.LRU = dofile(wea.modpath.."/utils/lru.lua")

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

dofile(wea.modpath.."/lib/count.lua")

dofile(wea.modpath.."/lib/bonemeal.lua")
dofile(wea.modpath.."/lib/forest.lua")

dofile(wea.modpath.."/lib/ellipsoidapply.lua")
dofile(wea.modpath.."/lib/airapply.lua")

dofile(wea.modpath.."/lib/subdivide.lua")
dofile(wea.modpath.."/lib/selection/stack.lua")
dofile(wea.modpath.."/lib/selection/cloud.lua")
