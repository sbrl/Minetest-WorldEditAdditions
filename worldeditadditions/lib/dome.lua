local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ██████   ██████  ███    ███ ███████
-- ██   ██ ██    ██ ████  ████ ██
-- ██   ██ ██    ██ ██ ████ ██ █████
-- ██   ██ ██    ██ ██  ██  ██ ██
-- ██████   ██████  ██      ██ ███████
--- Creates a dome shape with the given node, optionally specifying the
-- direction the point should point.
-- @param	pos				Vector3		The central point to start drawing the dome from.
-- @param	radius			number		The radius of the dome to create.
-- @param	replace_node	string		The fully qualified name of the node to use to make the dome with.
-- @param	pointing_dir	Vector3		Optional. The direction the dome should point. Defaults to (0, 1, 0). See also wea_c.parse.axis_name.
-- @param	hollow			boolean		Whether to make the dome hollow or not. Defaults to false.
function worldeditadditions.dome(pos, radius, replace_node, pointing_dir, hollow)
	pos = Vector3.clone(pos)
	local pos1 = pos - radius
	local pos2 = pos + radius
	
	if not pointing_dir then pointing_dir = Vector3.new(0, 1, 0) end
	if hollow == nil then hollow = false end
	
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_replace = minetest.get_content_id(replace_node)
	local radius_sq = radius * radius
	local radius_inner_sq = (radius-1) * (radius-1)
	local centrepoint = Vector3.mean(pos1, pos2)
	
	
	local replaced = 0
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local distance_sq = (Vector3.new(x, y, z) - centrepoint):length_squared()
				
				local is_in_range = distance_sq < radius_sq
				
				if hollow and distance_sq < radius_inner_sq then
					is_in_range = false
				end
				
				if is_in_range then
					-- It's inside the radius, but we're still not sure given this is a dome and not a sphere
					local should_include = false
					if x <= centrepoint.x and pointing_dir.x < 0 then
						should_include = true
					end
					if x >= centrepoint.x and pointing_dir.x > 0 then
						should_include = true
					end
					if y <= centrepoint.y and pointing_dir.y < 0 then
						should_include = true
					end
					if y >= centrepoint.y and pointing_dir.y > 0 then
						should_include = true
					end
					if z <= centrepoint.z and pointing_dir.z < 0 then
						should_include = true
					end
					if z >= centrepoint.z and pointing_dir.z > 0 then
						should_include = true
					end
					
					if should_include then
						data[area:index(x, y, z)] = node_id_replace
						replaced = replaced + 1
					end
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, replaced
end
