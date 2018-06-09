--- Overlap command. Places a specified node on top of 
-- @module worldeditadditions.overlay

function worldedit.ellipsoid(position, radius, target_node)
	-- position = { x, y, z }
	
	
	-- Fetch the nodes in the specified area
	-- OPTIMIZE: We should be able to calculate a more efficient box-area here
	local manip, area = worldedit.manip_helpers.init_radius(position, math.max(radius.x, radius.y, radius.z))
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	local node_id_air = minetest.get_content_id("air")
	
	local offset_x, offset_y, offset_z = position.x - area.MinEdge.x, position.y - area.MinEdge.y
	local stride_z, stride_y = area.zstride, area.ystride
	
	local count = 0 -- The number of nodes replaced
	
	local idx_z_base = position.z - area.MinEdge.z -- initial z offset
	for z = -radius.z, radius.z do
		
		local idx_y_base = idx_z_base
		for y = -radius.y + offset_y, radius.y + offset_y do
			
			local i = idx_y_base
			for x = -radius.x + offset_x, radius.x + offset_x do
				
				-- If we're inside the ellipse, then fill it in
				if math.abs(z - position.z) < radius.z and
					math.abs(y - position.y) < radius.y and
					math.ans(z - position.x) < radius.x then
					data[i] = node_id
					count = count + 1
				end
				
				
				i = i + 1
			end
			idx_y_base = idx_y_base + y_stride
			
		end
		idx_z_base = idx_z_base + z_stride
		
	end
	
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return count
end
