local wea = worldeditadditions
local wea_c = worldeditadditions_core
wea.erode = {}

dofile(wea.modpath.."/lib/erode/snowballs.lua")
dofile(wea.modpath.."/lib/erode/river.lua")
dofile(wea.modpath.."/lib/erode/3d.lua")


function wea.erode.run(pos1, pos2, algorithm, params)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local success, msg, stats
	if algorithm == "3d" then
		-- currently, we only have the 1 3D algorithm so that's what we'll do here
		-- FUTURE: add ergonomic 2d/3d algorithm detection and matching here
		
		success, stats = wea.erode.erode_3d(pos1, pos2, area, data, params)
		if not success then return success, stats end
		
		msg = tostring(stats.nodes_replaced_actual).."/"..tostring(stats.nodes_replaced_target).." nodes replaced with "..tostring(stats.attempts_failed).." failed attempts, averaging "..tostring(stats.attempts_taken_average).." attempts/node replaced"
		
	else
		-- it's a 2d algorithm
		local heightmap_size = {
			z = (pos2.z - pos1.z) + 1,
			x = (pos2.x - pos1.x) + 1
		}
		
		local region_height = (pos2.y - pos1.y) + 1
		
		local heightmap = wea_c.terrain.make_heightmap(pos1, pos2, manip, area, data)
		local heightmap_eroded = wea_c.table.shallowcopy(heightmap)
		
		-- print("[erode.run] algorithm: "..algorithm..", params:");
		-- print(wea_c.format.map(params))
		-- wea_c.format.array_2d(heightmap, heightmap_size.x)
		if algorithm == "snowballs" then
			success, msg = wea.erode.snowballs(
				heightmap, heightmap_eroded,
				heightmap_size,
				region_height,
				params
			)
			if not success then return success, msg end
		elseif algorithm == "river" then
			success, msg = wea.erode.river(
				heightmap, heightmap_eroded,
				heightmap_size,
				region_height,
				params
			)
			if not success then return success, msg end
		else
			-- FUTURE: Add a new "river" algorithm here that:
			-- * Fills in blocks that are surrounded on more than 3 horizontal sides
			-- * Destroys blocks that have no horizontal neighbours
			-- A bit like cellular automata actually.
			return false, "Error: Unknown algorithm '"..algorithm.."'. Currently implemented algorithms: snowballs (2d; hydraulic-like), river (2d; cellular automata-like; fills potholes and lowers towers). Ideas for algorithms to implement are welcome!"
		end
		
		success, stats = wea_c.terrain.apply_heightmap_changes(
			pos1, pos2, area, data,
			heightmap, heightmap_eroded, heightmap_size
		)
		if not success then return success, stats end
	end
	
	-- doesn't matter what we did it needs saving
	worldedit.manip_helpers.finish(manip, data)
	
	
	return true, msg, stats
end
