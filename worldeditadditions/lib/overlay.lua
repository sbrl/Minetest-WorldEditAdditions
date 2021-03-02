--- Overlap command. Places a specified node on top of each column.
-- @module worldeditadditions.overlay

function worldeditadditions.overlay(pos1, pos2, node_weights)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_ignore = minetest.get_content_id("ignore")
	
	local node_ids, node_ids_count = worldeditadditions.make_weighted(node_weights)
	
	-- minetest.log("action", "pos1: " .. worldeditadditions.vector.tostring(pos1))
	-- minetest.log("action", "pos2: " .. worldeditadditions.vector.tostring(pos2))
	
	-- z y x is the preferred loop order, but that isn't really possible here
	
	local changes = { updated = 0, skipped_columns = 0, placed = {} }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			local found_air = false
			local placed_node = false
			-- print("\n\n[overlay] ****** column start ******")
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				-- print("[overlay] pos", x, y, z, "id", data[i], "name", minetest.get_name_from_content_id(data[i]), "is_liquid", worldeditadditions.is_liquidlike(data[i]))
				
				local is_air = worldeditadditions.is_airlike(data[i])
				local is_liquid = worldeditadditions.is_liquidlike(data[i])
				-- wielded_light is now handled by worldeditadditions.is_airlike
				
				local is_ignore = data[i] == node_id_ignore
				
				if not is_air and not is_ignore then
					local i_above = area:index(x, y + 1, z)
					if found_air and not is_liquid then
						local new_id = node_ids[math.random(node_ids_count)]
						-- We've found an air block previously, so it must be above us
						-- Replace the node above us with the target block
						data[i_above] = new_id
						changes.updated = changes.updated + 1
						placed_node = true
						if not changes.placed[new_id] then
							changes.placed[new_id] = 0
						end
						changes.placed[new_id] = changes.placed[new_id] + 1
						-- print("[overlay] placed above ", x, y, z)
						break -- Move on to the next column
					end
				elseif not is_ignore and not is_liquid then
					-- print("[overlay] found air at", x, y, z)
					found_air = true
				end
				if is_liquid then found_air = false end
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
