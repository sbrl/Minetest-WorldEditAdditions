local weac = worldeditadditions_core

local wall_entity_lists = {}

--- Ensures that a table exists for the given player.
-- @param	player_name		string	The name of the player to check.
local function ensure_player(player_name)
	if player_name == nil then
		minetest.log("error", "[wea core:pos_manage:ensure_player] player_name is nil")
	end
	if not wall_entity_lists[player_name] then
		wall_entity_lists[player_name] = {}
	end
end

--- Deletes the currently displayed marker wall.
-- @param	event	EventArgs<wea_c.pos.set>	The event args for the set, push, pop, or clear events on wea_c.pos.
-- @returns	void
local function do_delete(event)
	if not wall_entity_lists[event.player_name] then return end
	-- print("DEBUG:marker_wall_manage do_delete --> deleting pre-existing wall with "..tostring(#wall_entity_lists[event.player_name]).." entities")
	if #wall_entity_lists[event.player_name] > 0 then
		weac.entities.pos_marker_wall.delete(wall_entity_lists[event.player_name])
	end

	wall_entity_lists[event.player_name] = nil
end

--- Updates the marker wall as appropriate.
-- @param	event	EventArgs<wea_c.pos.set>	The event args for the set, push, or pop events on wea_c.pos.
-- @returns	void
local function do_update(event)
	-- print("DEBUG:marker_wall_manage do_update --> START")
	-- We don't dynamically update, as that'd be too much work.
	-- Instead, we just delete & recreate each time.
	if wall_entity_lists[event.player_name] then
		-- print("DEBUG:marker_wall_manage do_update --> do_delete")
		do_delete(event)
	end
	
	local pos1 = weac.pos.get1(event.player_name)
	local pos2 = weac.pos.get2(event.player_name)
	-- print("DEBUG:marker_wall_manage do_update --> pos1", pos1, "pos2", pos2)
	
	if not pos1 or not pos2 then return end
	
	wall_entity_lists[event.player_name] = weac.entities.pos_marker_wall.create(
		event.player_name,
		pos1,
		pos2
	)
	-- print("DEBUG:marker_wall_manage do_update --> entitylist", weac.inspect(wall_entity_lists[event.player_name]))
end


local function garbage_collect(player_name)
	if not wall_entity_lists[player_name] then return end -- Nothing to do
	
	for i, entity in ipairs(wall_entity_lists[player_name]) do
		if not entity:get_pos() then
			table.remove(wall_entity_lists[player_name], i)
		end
	end
end

local function update_entity(event)
	print("DEBUG:pos_marker_wall_manage UPDATE_ENTITY event", weac.inspect(event))
	garbage_collect(event.player_name)
	
	ensure_player(event.player_name)
	table.insert(
		wall_entity_lists[event.player_name],
		event.entity
	)
end

local function needs_update(event)
	if event.i > 2 then
		return false
	end
	return true
end

local function handle_event(event)
	if needs_update(event) then do_update(event) end
end

local function handle_unmark(event)
	if event.walls then do_delete(event) end
end

weac.pos:addEventListener("set", handle_event)
weac.pos:addEventListener("pop", handle_event)
weac.pos:addEventListener("push", handle_event)
weac.pos:addEventListener("clear", do_delete)

weac.pos:addEventListener("unmark", handle_unmark)
weac.pos:addEventListener("mark", do_update)

weac.entities.pos_marker_wall:addEventListener("update_entity", update_entity)