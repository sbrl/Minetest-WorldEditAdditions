local wea_c = worldeditadditions_core

local position_entities = {}

local function compat_worldedit_hide_pos1(player_name)
	if not worldedit or not worldedit.pos1 or not worldedit.mark_pos1 then return end
	local pos1 = worldedit.pos1[player_name]
	worldedit.pos1[player_name] = nil
	worldedit.mark_pos1(player_name)
	worldedit.pos1[player_name] = pos1
end
local function compat_worldedit_hide_pos2(player_name)
	if not worldedit or not worldedit.pos2 or not worldedit.mark_pos2 then return end
	local pos2 = worldedit.pos2[player_name]
	worldedit.pos2[player_name] = nil
	worldedit.mark_pos2(player_name)
	worldedit.pos2[player_name] = pos2
end

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
	
	if event.i == 1 then compat_worldedit_hide_pos1(event.player_name) end
	if event.i == 2 then compat_worldedit_hide_pos2(event.player_name) end
	
	local new_entity = wea_c.entities.pos_marker.create(
		event.player_name,
		event.pos,
		event.i
	)
	position_entities[event.player_name][event.i] = new_entity
end

local function do_delete_all(player_name)
	if #position_entities[player_name] > 0 then
		for _, entity in pairs(position_entities[player_name]) do
			wea_c.entities.pos_marker.delete(entity)
		end
	end
	position_entities[player_name] = nil
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
	do_delete_all(event.player_name)
	
	-- For compatibility, ensure that we also clear the legacy worldedit region too
	if worldedit and worldedit.marker_update then
		worldedit.marker_update(event.player_name)
	end
end)

wea_c.pos:addEventListener("unmark", function(event)
	ensure_player(event.player_name)
	
	if event.markers then
		do_delete_all(event.player_name)
	end
	-- Note that this function is NOT WorldEdit compatible, because it is only called through our override of WorldEdit's `//unmark`, and WorldEdit doesn't have an API function to call to unmark and everything is complicated.
end)

wea_c.pos:addEventListener("mark", function(event)
	ensure_player(event.player_name)
	
	do_delete_all(event.player_name)
	
	for i, pos in pairs(wea_c.pos.get_all(event.player_name)) do
		do_create({
			player_name = event.player_name,
			i = i,
			pos = pos
		})
	end
end)


wea_c.entities.pos_marker:addEventListener("update_entity", function(event)
	wea_c.entities.pos_marker.delete(
		position_entities[event.player_name][event.i]
	)
	position_entities[event.player_name][event.i] = event.entity
end)
