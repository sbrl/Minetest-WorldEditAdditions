
--- Raycasts to find a node in the direction the given player is looking.
-- @param	player			Player	The player object to raycast from.
-- @param	maxdist			number	The maximum distance to raycast.
-- @param	skip_liquid		bool	Whether to skip liquids when raycasting.
-- @return	position, number		nil if nothing was found (or unloaded chunks were hit), or the position as an {x, y, z} table and the node id if something was found.
function worldeditadditions.raycast(player, maxdist, skip_liquid)
	if maxdist == nil then maxdist = 100 end
	if skip_liquid == nil then skip_liquid = false end
	local look_dir = player:get_look_dir()
	
	local node_id_ignore = minetest.get_content_id("ignore")
	local cur_pos = {}
	local player_pos = player:getpos()
	player_pos.y = player_pos.y + 1.5 -- Calculate from the eye position
	
	for i = 1, maxdist do
		local j = i / 10
		
		cur_pos.x = (look_dir.x*j) + player_pos.x
		cur_pos.y = (look_dir.y*j) + player_pos.y
		cur_pos.z = (look_dir.z*j) + player_pos.z
		
		local found_node = false
		
		local node = minetest.get_node_or_nil(cur_pos)
		if node ~= nil then
			local node_id = minetest.get_content_id(node.name)
			local is_air = worldeditadditions.is_airlike(node_id)
			
			-- ignore = unloaded chunks, as far as I can tell
			if node_id == node_id_ignore then
				return nil
			end
			
			if is_air == false then
				if skip_liquid == true then
					return cur_pos, node_id
				elseif worldeditadditions.is_liquidlike(node_id) == true then
					return cur_pos, node_id
				end
			end
		end
	end
	
	return nil
end
