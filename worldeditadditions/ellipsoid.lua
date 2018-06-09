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
	
	local stride_z, stride_y = area.zstride, area.ystride
	-- TODO:  This won't work, because we need to vary the calculation we use this in based on what part of the ellipsoid we're working on / in, not compare to a static value
	local radius_distance_sq = worldeditadditions.vector.lengthsquared(radius)
	
	local count = 0 -- The number of nodes replaced
	
	local idx_z_base = area:index(position.x, position.y, position.z) -- initial z offset
	for z = -radius.z, radius.z do
		
		local idx_y_base = idx_z_base
		for y = -radius.y, radius.y do
			
			local i = idx_y_base
			for x = -radius.x, radius.x do
				
				-- If we're inside the ellipse, then fill it in
				if (x/radius.x)*(x/radius.x) + (y/radius.y)*(y/radius.y) + (z/radius.z)*(z/radius.z) <= 1 then


					data[i] = node_id
					count = count + 1
				
				end
				
				
				i = i + 1
			end
			idx_y_base = idx_y_base + stride_y
			
		end
		idx_z_base = idx_z_base + stride_z
		
	end
	
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return count
end
