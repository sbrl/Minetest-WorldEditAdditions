-- ███████ ██      ██      ██ ██████  ███████ ███████
-- ██      ██      ██      ██ ██   ██ ██      ██
-- █████   ██      ██      ██ ██████  ███████ █████
-- ██      ██      ██      ██ ██           ██ ██
-- ███████ ███████ ███████ ██ ██      ███████ ███████

--- Fills an ellipsoidal area around the given position with the target node.
-- The resulting ellipsoid may optionally be hollow (in which case
-- nodes inside the ellipsoid are left untouched).
-- @param	position	Vector3		The centre position of the ellipsoid.
-- @param	radius		Vector3		The radius of the ellipsoid in all 3 dimensions.
-- @param	target_node	string		The name of the node to use to fill the ellipsoid.
-- @param	hollow		bool		Whether the ellipsoid should be hollow or not.
-- @returns	number		The number of nodes filled to create the (optionally hollow) ellipsoid. This number will be lower with hollow ellipsoids, since the internals of an ellipsoid aren't altered.
function worldeditadditions.ellipsoid(position, radius, target_node, hollow)
	-- position = { x, y, z }
	local hollow_inner_radius = {
		x = radius.x - 1,
		y = radius.y - 1,
		z = radius.z - 1
	}
	
	-- Fetch the nodes in the specified area
	-- OPTIMIZE: We should be able to calculate a more efficient box-area here
	local manip, area = worldedit.manip_helpers.init_radius(position, math.max(radius.x, radius.y, radius.z))
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	
	local stride_z, stride_y = area.zstride, area.ystride
	
	local count = 0 -- The number of nodes replaced
	
	local idx_z_base = area:index(position.x - radius.x, position.y - radius.y, position.z - radius.z) -- initial z offset
	for z = -radius.z, radius.z do
		
		local idx_y_base = idx_z_base
		for y = -radius.y, radius.y do
			
			local i = idx_y_base
			for x = -radius.x, radius.x do
				
				-- If we're inside the ellipse, then fill it in
				local x_comp, y_comp, z_comp = x/radius.x, y/radius.y, z/radius.z
				local ellipsoid_dist = x_comp*x_comp + y_comp*y_comp + z_comp*z_comp
				if ellipsoid_dist <= 1 then
					local place_ok = not hollow;
					
					if not place_ok then
						-- It must be hollow! Do some additional calculations.
						local hx_comp = x/hollow_inner_radius.x
						local hy_comp = y/hollow_inner_radius.y
						local hz_comp = z/hollow_inner_radius.z
						
						-- It's only ok to place it if it's outside our inner ellipse
						place_ok = hx_comp*hx_comp + hy_comp*hy_comp + hz_comp*hz_comp >= 1
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
