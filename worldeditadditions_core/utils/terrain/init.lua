local wea = worldeditadditions
local Vector3 = wea.Vector3


local terrain = {
	make_heightmap = dofile(wea.modpath.."/utils/terrain/make_heightmap.lua"),
	calculate_normals = dofile(wea.modpath.."/utils/terrain/calculate_normals.lua"),
	calculate_slopes = dofile(wea.modpath.."/utils/terrain/calculate_slopes.lua"),
	apply_heightmap_changes = dofile(wea.modpath.."/utils/terrain/apply_heightmap_changes.lua")
}

return terrain
