--- Overlap command. Places a specified node on top of each column.
-- @module worldeditadditions.layers

function worldeditadditions.layers(pos1, pos2, node_weights)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_ignore = minetest.get_content_id("ignore")
	
	local node_ids, node_ids_count = worldeditadditions.unwind_node_list(node_weights)
	
	-- minetest.log("action", "pos1: " .. worldeditadditions.vector.tostring(pos1))
	-- minetest.log("action", "pos2: " .. worldeditadditions.vector.tostring(pos2))
	-- for i,v in ipairs(node_ids) do
	-- 	print("[layer] i", i, "node id", v)
	-- end
	-- z y x is the preferred loop order, but that isn't really possible here
	
	local changes = { replaced = 0, skipped_columns = 0 }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			local next_index = 1 -- We use table.insert() in make_weighted
			local placed_node = false
			
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				
				local is_air = worldeditadditions.is_airlike(data[i])
				local is_ignore = data[i] == node_id_ignore
				
				if not is_air and not is_ignore then
					-- It's not an airlike node or something else odd
					data[i] = node_ids[next_index]
					next_index = next_index + 1
					changes.replaced = changes.replaced + 1
					
					-- If we're done replacing nodes in this column, move to the next one
					if next_index > #node_ids then
						break
					end
				end
			end
			
			if not placed_node then
				changes.skipped_columns = changes.skipped_columns + 1
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return changes
end
