
--- worldeditadditions.raycast() wrapper
function worldeditadditions.farwand.do_raycast(player)
	if player == nil then return nil end
	local player_name = player:get_player_name()
	
	if worldeditadditions.farwand.player_data[player_name] == nil then
		worldeditadditions.farwand.player_data[player_name] = { maxdist = 1000, skip_liquid = true }
	end
	
	local looking_pos, node_id = worldeditadditions.raycast(
		player, 
		worldeditadditions.farwand.player_data[player_name].maxdist,
		worldeditadditions.farwand.player_data[player_name].skip_liquid
	)
	return looking_pos, node_id
end
