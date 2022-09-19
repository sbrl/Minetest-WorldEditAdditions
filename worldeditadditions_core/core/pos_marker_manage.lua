local wea_c = worldeditadditions_core

local position_entities = {}


--- Ensures that a table exists for the given player.
-- @param	player_name		string	The name of the player to check.
local function ensure_player(player_name)
	if player_name == nil then
		minetest.log("error", "[wea core:pos_manage:ensure_player] player_name is nil")
	end
	if not position_entities[player_name] then
		position_entities[player_name] = {}
	end
end

wea_c.pos:addEventListener("push", function(event)
	ensure_player(event.player_name)
	
	local new_entity = wea_c.entities.pos_marker.create(
		event.player_name,
		event.pos,
		event.i
	)
	position_entities[event.player_name][event.i] = new_entity
end)

wea_c.pos:addEventListener("pop", function(event)
	ensure_player(event.player_name)
	print("pos manage: pop", wea_c.inspect(event))
	if not position_entities[event.player_name][event.i] then return end
	wea_c.entities.pos_marker.delete(
		position_entities[event.player_name][event.i]
	)
	position_entities[event.player_name][event.i] = nil
end)