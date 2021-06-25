--- Generates torus shapes.
-- @module worldeditadditions.torus

--- Generates a torus shape at the given position with the given parameters.
-- @param	position		Vector		The position at which to generate the torus.
-- @param	major_radius	number		The major radius of the torus - i.e. the distance from the middle to the ring.
-- @param	minor_radius	number		The minor radius of the torus - i.e. the radius fo the ring itself.
-- @param	target_node		string		The name of the target node to generate the torus with.
-- @param	axes=xz			string|nil	The axes upon which the torus should lay flat.
-- @param	hollow=false	boolean		Whether the generated torus should be hollow or not.
function worldeditadditions.torus(position, major_radius, minor_radius, target_node, axes, hollow)
	local matrix = {x='yz', y='xz', z='xy'}
	if type(axes) ~= "string" then axes = "xz" end
	if #axes == 1 and axes:match('[xyz]') then axes = matrix[axes] end
	
	-- position = { x, y, z }
	local total_radius = major_radius + minor_radius
	local inner_minor_radius = minor_radius - 2
	local major_radius_sq = major_radius*major_radius
	local minor_radius_sq = minor_radius*minor_radius
	local inner_minor_radius_sq = inner_minor_radius*inner_minor_radius
	
	-- Fetch the nodes in the specified area
	-- OPTIMIZE: We should be able to calculate a more efficient box-area here
	-- This is complicated by the multiple possible axes though
	local manip, area = worldedit.manip_helpers.init_radius(position, total_radius)
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	local node_id_air = minetest.get_content_id("air")
	
	local stride_z, stride_y = area.zstride, area.ystride
	
	local count = 0 -- The number of nodes replaced
	
	local idx_z_base = area:index(position.x - total_radius, position.y - total_radius, position.z - total_radius) -- initial z offset
	for z = -total_radius, total_radius do
		local z_sq = z*z
		
		local idx_y_base = idx_z_base
		for y = -total_radius, total_radius do
			local y_sq = y*y
			
			local i = idx_y_base
			for x = -total_radius, total_radius do
				local x_sq = x*x
				
				local sq = vector.new(x_sq, y_sq, z_sq)
				
				-- Default: xy
				if axes == "xz" then
					sq.x, sq.y, sq.z = sq.x, sq.z, sq.y
				elseif axes == "yz" then
					sq.x, sq.y, sq.z = sq.y, sq.z, sq.x
				end
				
				-- (x^2+y^2+z^2-(a^2+b^2))^2-4 a b (b^2-z^2)
				-- Where:
				-- (x, y, z) is the point
				-- a is the major radius (centre of the ring to the centre of the torus)
				-- b is the minor radius (radius of the ring)
				local comp_a = (sq.x+sq.y+sq.z - (major_radius_sq+minor_radius_sq))
				local test_value = comp_a*comp_a - 4*major_radius*minor_radius*(minor_radius_sq-sq.z)
				
				-- If we're inside the torus, then fill it in
				if test_value <= 1 then
					local place_ok = not hollow;
					
					if not place_ok then
						-- It must be hollow! Do some additional calculations.
						local inner_comp_a = (sq.x+sq.y+sq.z - (major_radius_sq+inner_minor_radius_sq))
						local inner_test_value = inner_comp_a*inner_comp_a - 4*major_radius*inner_minor_radius*(inner_minor_radius_sq-sq.z)
						
						-- It's only ok to place it if it's outside our inner torus
						place_ok = inner_test_value >= 0
					end
					
					if place_ok then
						data[i] = node_id
						count = count + 1
					end
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
