-- ██   ██  ██████  ██      ██       ██████  ██     ██
-- ██   ██ ██    ██ ██      ██      ██    ██ ██     ██
-- ███████ ██    ██ ██      ██      ██    ██ ██  █  ██
-- ██   ██ ██    ██ ██      ██      ██    ██ ██ ███ ██
-- ██   ██  ██████  ███████ ███████  ██████   ███ ███
--- Hollows out the defined region, leaving a given number of nodes on the
-- outside.
-- (think of the bits of the outermost parts of the defined region as the
-- 'walls' to a box)
function worldeditadditions.hollow(pos1, pos2, wall_thickness)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_ignore = minetest.get_content_id("ignore")
	local node_id_air = minetest.get_content_id("air")
	
	-- minetest.log("action", "pos1: " .. worldeditadditions.vector.tostring(pos1))
	-- minetest.log("action", "pos2: " .. worldeditadditions.vector.tostring(pos2))
	
	local changes = { replaced = 0 }
	for z = pos2.z - wall_thickness, pos1.z + wall_thickness, -1 do
		for y = pos2.y - wall_thickness, pos1.y + wall_thickness, -1 do
			for x = pos2.x - wall_thickness, pos1.x + wall_thickness, -1 do
				local i = area:index(x, y, z)
				
				local is_air = worldeditadditions.is_airlike(data[i])
				local is_ignore = data[i] == node_id_ignore
				
				if not is_ignore and not is_air then
					data[i] = node_id_air
					changes.replaced = changes.replaced + 1
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, changes
end
