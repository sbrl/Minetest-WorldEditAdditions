local wea = worldeditadditions
local Vector3 = wea.Vector3

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
-- @parram	pointing_dir	Vector3		Optional. The direction the dome should point. Defaults to (0, 1, 0). See also wea.parse.axis_name.
function worldeditadditions.dome(pos, radius, replace_node, pointing_dir)
	pos = Vector3.clone(pos)
	local pos1 = pos - radius
	local pos2 = pos + radius
	
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_replace = minetest.get_content_id(replace_node)
	local radius_sq = radius * radius
	local centrepoint = Vector3.mean(pos1, pos2)
	
	
	local replaced = 0
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local distance_sq = (Vector3.new(x, y, z) - centrepoint):length_squared()
				
				if distance_sq < radius_sq then
					-- It's inside the radius, but we're still not sure given this is a dome and not a sphere
					local should_include = false
					if x < centrepoint.x and pointing_dir.x < 0 then
						should_include = true
					end
					if x > centrepoint.x and pointing_dir.x > 0 then
						should_include = true
					end
					if y < centrepoint.y and pointing_dir.y < 0 then
						should_include = true
					end
					if y > centrepoint.y and pointing_dir.y > 0 then
						should_include = true
					end
					if z < centrepoint.z and pointing_dir.z < 0 then
						should_include = true
					end
					if z > centrepoint.z and pointing_dir.z > 0 then
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
