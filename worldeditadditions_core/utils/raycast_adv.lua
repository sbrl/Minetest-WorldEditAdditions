local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3
--- Raycasts to find a node in the direction the given player is looking.
-- @param	player			Player	The player object to raycast from.
-- @param	maxdist			number	The maximum distance to raycast.
-- @param	skip_liquid		bool	Whether to skip liquids when raycasting.
-- @return	position, number		nil if nothing was found (or unloaded chunks were hit), or the position as an {x, y, z} table and the node id if something was found.
function wea_c.raycast(player, maxdist, skip_liquid)
	if maxdist == nil then maxdist = 100 end
	if skip_liquid == nil then skip_liquid = false end
	local look_dir = Vector3.clone(player:get_look_dir())
	
	local node_id_ignore = minetest.get_content_id("ignore")
	local cur_pos
	local player_pos = player:get_pos()
	player_pos.y = player_pos.y + 1.5 -- Calculate from the eye position
	
	local divisor = 5
	for i = 1, maxdist do
		local j = i / divisor
		
		cur_pos = (look_dir * j) + player_pos
				
		local node_pos = cur_pos:round()
		
		-- Don't bother if this is the same position we were looking at before
		if not (node_pos.x == math.floor(0.5+look_dir.x*(j-divisor))
			and node_pos.y == math.floor(0.5+look_dir.y*(j-divisor))
			and node_pos.z == math.floor(0.5+look_dir.z*(j-divisor))) then
			
			local found_node = false
			
			local node = minetest.get_node_or_nil(node_pos)
			if node ~= nil then
				local node_id = minetest.get_content_id(node.name)
				local is_air = wea_c.is_airlike(node_id)
				
				-- ignore = unloaded chunks, as far as I can tell
				if node_id == node_id_ignore then
					return nil
				end
				
				if is_air == false then
					if skip_liquid == false then
						return node_pos, node_id
					else
						local is_liquid = wea_c.is_liquidlike(node_id)
						if is_liquid == false then
							return node_pos, node_id
						end
					end
				end
			end
			
		end
	end
	
	return nil
end
