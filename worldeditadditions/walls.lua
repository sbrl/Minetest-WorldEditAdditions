--- Creates vertical walls on the inside of the defined region.
-- @module worldeditadditions.walls

-- ██     ██  █████  ██      ██      ███████
-- ██     ██ ██   ██ ██      ██      ██
-- ██  █  ██ ███████ ██      ██      ███████
-- ██ ███ ██ ██   ██ ██      ██           ██
--  ███ ███  ██   ██ ███████ ███████ ███████

function worldeditadditions.walls(pos1, pos2, node_name)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(node_name)
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	local count_replaced = 0
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				if x == pos1.x or x == pos2.x or z == pos1.z or z == pos2.z then
					data[area:index(x, y, z)] = node_id
					count_replaced = count_replaced + 1
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, count_replaced
end
