local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

--- Fill caves command. Fills underneath non-air nodes in the defined region.
-- @param	pos1		Vector3		pos1 of the defined region to fill caves in.
-- @param	pos2		Vector3		pos2 of the defined region to fill caves in.
-- @param	node_name	string		The name of the node to replace air nodes with. Should have been already normalised, as with all other worldeditadditions.* functions.
-- @returns	bool,{replaced=number}	1. Whether the fill caves operation was successful or not.
-- 									2. A table of statistics about the operation. Currently the only key in this table is `replaced`, which is the number of (air-like) nodes that were replaced during the operation.
function worldeditadditions.fillcaves(pos1, pos2, node_name)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_replace = minetest.get_content_id(node_name)
	local node_id_ignore = minetest.get_content_id("ignore")
	
	-- minetest.log("action", "pos1: " .. pos1)
	-- minetest.log("action", "pos2: " .. pos2)
	
	-- z y x is the preferred loop order, but that isn't really possible here
	
	local changes = { replaced = 0 }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			local is_first_node_in_col = true
			local prev_is_air = false
			local found_toplayer = false
			
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				
				local is_air = wea_c.is_airlike(data[i]) or wea_c.is_liquidlike(data[i])
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
