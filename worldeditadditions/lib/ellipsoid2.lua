local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██      ██      ██ ██████  ███████ ███████
-- ██      ██      ██      ██ ██   ██ ██      ██
-- █████   ██      ██      ██ ██████  ███████ █████
-- ██      ██      ██      ██ ██           ██ ██
-- ███████ ███████ ███████ ██ ██      ███████ ███████


function worldeditadditions.ellipsoid2(pos1, pos2, target_node, hollow)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	local volume = pos2 - pos1
	local volume_half = volume / 2
	
	local radius = (pos2 - pos1) / 2
	
	-- print("DEBUG:ellipsoid2 | pos1: "..pos1..", pos2: "..pos2..", target_node: "..target_node)
	-- print("DEBUG:ellipsoid2 radius", radius)
	
	-- position = { x, y, z }
	local hollow_inner_radius = radius - 1
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	
	local count = 0 -- The number of nodes replaced
	
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local here = Vector3.new(x, y, z)
				local pos_relative = (here - pos1) - volume_half
				
				-- print("DEBUG pos1", pos1, "pos2", pos2, "volume_half", volume_half, "pos_relative", pos_relative)
				
				-- If we're inside the ellipse, then fill it in
				local comp = pos_relative / radius
				local ellipsoid_dist = comp:length_squared()
				if ellipsoid_dist <= 1 then
					local place_ok = not hollow;
					
					if not place_ok then
						-- It must be hollow! Do some additional calculations.
						local h_comp = here / hollow_inner_radius
						
						-- It's only ok to place it if it's outside our inner ellipse
						place_ok = Vector3.dot(h_comp, h_comp) >= 1
					end
					
					if place_ok then
						data[area:index(x, y, z)] = node_id
						count = count + 1
					end
				end
				
			end
		end
	end
	
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return count
end
