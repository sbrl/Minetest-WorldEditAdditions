
-- ██     ██  █████  ██      ██      ███████
-- ██     ██ ██   ██ ██      ██      ██
-- ██  █  ██ ███████ ██      ██      ███████
-- ██ ███ ██ ██   ██ ██      ██           ██
--  ███ ███  ██   ██ ███████ ███████ ███████

--- Creates vertical walls on the inside of the defined region.
-- @apipath worldeditadditions.walls
-- @param	pos1		Vector	Position 1 of the defined region,
-- @param	pos2		Vector	Position 2 of the defined region.
-- @param	node_name	string	The name of the node to use to create the walls with.
-- @param	thickness	number?	The thickness of the walls to create. Default: 1
function worldeditadditions.walls(pos1, pos2, node_name, thickness)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if not thickness then thickness = 1 end
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
				if math.abs(x - pos1.x) < thickness
					or math.abs(x - pos2.x) < thickness
					or math.abs(z - pos1.z) < thickness
					or math.abs(z - pos2.z) < thickness then
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
