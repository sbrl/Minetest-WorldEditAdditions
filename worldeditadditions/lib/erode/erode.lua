worldeditadditions.erode = {}

dofile(worldeditadditions.modpath.."/lib/erode/snowballs.lua")


function worldeditadditions.erode.run(pos1, pos2, algorithm, params)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local heightmap_size = {}
	heightmap_size[0] = (pos2.z - pos1.z) + 1
	heightmap_size[1] = (pos2.x - pos1.x) + 1
	
	local heightmap = worldeditadditions.make_heightmap(pos1, pos2, manip, area, data)
	local heightmap_eroded = worldeditadditions.shallowcopy(heightmap)
	
	print("[erode.run] algorithm: "..algorithm..", params:");
	print(worldeditadditions.map_stringify(params))
	worldeditadditions.print_2d(heightmap, heightmap_size[1])
	
	if algorithm == "snowballs" then
		local success, msg = worldeditadditions.erode.snowballs(heightmap_eroded, heightmap_size, params)
		if not success then return success, msg end
	else
		return false, "Error: Unknown algorithm '"..algorithm.."'. Currently implemented algorithms: snowballs (2d; hydraulic-like). Ideas for algorithms to implement are welcome!"
	end
	
	local success, msg = worldeditadditions.apply_heightmap_changes(
		pos1, pos2, area, data,
		heightmap, heightmap_eroded, heightmap_size
	)
	if not success then return success, msg end
	
	worldedit.manip_helpers.finish(manip, data)
	
	return true, stats
end
