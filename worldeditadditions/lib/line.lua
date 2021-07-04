--- Counts the nodes in a given area.
-- @module worldeditadditions.count

-- ██      ██ ███    ██ ███████
-- ██      ██ ████   ██ ██
-- ██      ██ ██ ██  ██ █████
-- ██      ██ ██  ██ ██ ██
-- ███████ ██ ██   ████ ███████
function worldeditadditions.line(pos1, pos2, thickness, node_name)
	local pos1_sorted, pos2_sorted = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	pos1 = vector.new(pos1)
	pos2 = vector.new(pos2)
	
	local node_id_replace = minetest.get_content_id(node_name)
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	local counts = { replaced = 0 }
	for z = pos2_sorted.z, pos1_sorted.z, -1 do
		for x = pos2_sorted.x, pos1_sorted.x, -1 do
			for y = pos2_sorted.y, pos1_sorted.y, -1 do
				local here = vector.new(x, y, z)
				local D = vector.normalize(
					vector.subtract(pos2, pos1)
				)
				local d = vector.dot(vector.subtract(here, pos1), D)
				local closest_on_line = vector.add(
					pos1,
					vector.multiply(D, d)
				)
				local distance = vector.length(vector.subtract(here, closest_on_line))
				
				if distance < thickness then
					data[area:index(x, y, z)] = node_id_replace
					counts.replaced = counts.replaced + 1
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, counts
end
