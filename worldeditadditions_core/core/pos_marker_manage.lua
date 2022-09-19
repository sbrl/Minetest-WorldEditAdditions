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


local function do_create(event)
	ensure_player(event.player_name)
	
	local new_entity = wea_c.entities.pos_marker.create(
		event.player_name,
		event.pos,
		event.i
	)
	position_entities[event.player_name][event.i] = new_entity
end

wea_c.pos:addEventListener("push", function(event)
	do_create(event)
end)

wea_c.pos:addEventListener("pop", function(event)
	ensure_player(event.player_name)
	if not position_entities[event.player_name][event.i] then return end
	wea_c.entities.pos_marker.delete(
		position_entities[event.player_name][event.i]
	)
	position_entities[event.player_name][event.i] = nil
end)

wea_c.pos:addEventListener("set", function(event)
	ensure_player(event.player_name)
	-- Delete the old one, if it exists
	-- This is safer than attempting to reuse an entity that might not exist
	if position_entities[event.player_name][event.i] then
		wea_c.entities.pos_marker.delete(
			position_entities[event.player_name][event.i]
		)
		position_entities[event.player_name][event.i] = nil
	end
	
	do_create(event) -- This works because the event obj for push and set is identical
end)

wea_c.pos:addEventListener("clear", function(event)
	ensure_player(event.player_name)
	if #position_entities[event.player_name] > 0 then
		for _, entity in pairs(position_entities[event.player_name]) do
			wea_c.entities.pos_marker.delete(entity)
		end
	end
	position_entities[event.player_name] = nil
end)