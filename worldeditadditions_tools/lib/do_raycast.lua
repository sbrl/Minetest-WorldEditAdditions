local wea_c = worldeditadditions_core
--- worldeditadditions.raycast() wrapper
function worldeditadditions_tools.do_raycast(player)
	if player == nil then return nil end
	local player_name = player:get_player_name()
	
	if worldeditadditions_tools.player_data[player_name] == nil then
		worldeditadditions_tools.player_data[player_name] = { maxdist = 1000, skip_liquid = true }
	end
	
	local looking_pos, node_id = wea_c.raycast(
		player, 
		worldeditadditions_tools.player_data[player_name].maxdist,
		worldeditadditions_tools.player_data[player_name].skip_liquid
	)
	return looking_pos, node_id
end
