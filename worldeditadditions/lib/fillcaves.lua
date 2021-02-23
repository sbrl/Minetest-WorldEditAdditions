--- Overlap command. Places a specified node on top of each column.
-- @module worldeditadditions.overlay

function worldeditadditions.fillcaves(pos1, pos2, node_name)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_replace = minetest.get_content_id(node_name)
	local node_id_ignore = minetest.get_content_id("ignore")
	
	-- minetest.log("action", "pos1: " .. worldeditadditions.vector.tostring(pos1))
	-- minetest.log("action", "pos2: " .. worldeditadditions.vector.tostring(pos2))
	
	-- z y x is the preferred loop order, but that isn't really possible here
	
	local changes = { replaced = 0 }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			local is_first_node_in_col = true
			local prev_is_air = false
			local found_toplayer = false
			
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				
				local is_air = worldeditadditions.is_airlike(data[i]) or worldeditadditions.is_liquidlike(data[i])
				local is_ignore = data[i] == node_id_ignore
				
				-- If the previous node was air and this one isn't, then we've found the top level
				if prev_is_air and not is_air then
					found_toplayer = true
				elseif is_first_node_in_col and not is_air then
					found_toplayer = true
				elseif found_toplayer and is_air and not is_ignore then
					-- We've found the top layer already and this node is air,
					-- so we should fill it in
					data[i] = node_id_replace
					changes.replaced = changes.replaced + 1
				end
				
				is_first_node_in_col = false
				prev_is_air = is_air
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, changes
end
