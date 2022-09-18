local wea_c = worldeditadditions_core

local terrain = {
	make_heightmap = dofile(wea_c.modpath.."/utils/terrain/make_heightmap.lua"),
	calculate_normals = dofile(wea_c.modpath.."/utils/terrain/calculate_normals.lua"),
	calculate_slopes = dofile(wea_c.modpath.."/utils/terrain/calculate_slopes.lua"),
	apply_heightmap_changes = dofile(wea_c.modpath.."/utils/terrain/apply_heightmap_changes.lua")
}

return terrain
