local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

local positions_count_limit = 999
local positions = {}

--- Position manager.
-- @namespace worldeditadditions_core.pos
local anchor = nil


--- A new position has been set in a player's list at a specific position.
-- @event	set
-- @format	{ player_name: string, i: number, pos: Vector3 }
-- @example
-- {
-- 	player_name = "some_player_name",
-- 	i = 3,
-- 	pos = <Vector3> { x = 456, y = 64, z = 9045 }
-- }

--- A new position has been pushed onto a player's stack.
-- @event	push
-- @format	{ player_name: string, i: number, pos: Vector3 }

--- A new position has been pushed onto a player's stack.
-- @event	pop
-- @format	{ player_name: string, i: number, pos: Vector3 }

--- The positions for a player have been cleared.
-- @event	clear
-- @format	{ player_name: string }

--- It is requested that all position/region marker UI elements be hidden for the given player.
-- @event	unmark
-- @format	{ player_name: string, markers: bool, walls: bool }

--- It is requested that all position/region marker UI elements be shown once more for the given player.
-- @event	mark
-- @format	{ player_name: string }

--- Ensures that a table exists for the given player.
-- @param	player_name		string	The name of the player to check.
local function ensure_player(player_name)
	if player_name == nil then
		minetest.log("error", "[wea core:pos:ensure_player] player_name is nil")
	end
	if not positions[player_name] then
		positions[player_name] = {}
	end
end

--- Transparently fetches from worldedit pos1 for compatibility.
-- Called whenever pos1 is accessed in this API.
-- @private
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	void
local function compat_worldedit_pos1_get(player_name)
	if worldedit and worldedit.pos1 and worldedit.pos1[player_name] then
		ensure_player(player_name)
		local new_pos1 = Vector3.clone(worldedit.pos1[player_name])
		local existing_pos1 = positions[player_name][1]
		positions[player_name][1] = new_pos1
		if new_pos1 ~= existing_pos1 then
			anchor:emit("set", { player_name = player_name, i = 1, pos = new_pos1 })
		end
	end
end
--- Transparently fetches from worldedit pos2 for compatibility.
-- Called whenever pos2 is accessed in this API.
-- @private
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	void
local function compat_worldedit_pos2_get(player_name)
	if worldedit and worldedit.pos2 and worldedit.pos2[player_name] then
		ensure_player(player_name)
		local new_pos2 = Vector3.clone(worldedit.pos2[player_name])
		local existing_pos2 = positions[player_name][2]
		positions[player_name][2] = new_pos2
		if new_pos2 ~= existing_pos2 then
			anchor:emit("set", { player_name = player_name, i = 2, pos = new_pos2 })
		end
	end
end

--- Sets pos1/pos2 in worldedit for compatibility.
-- @param	player_name		string	The name of the player to set the position for.
-- @param	i				number	The index of the position to set.
-- @param	pos				Vector3	The position to set.
-- @param	do_update=true	bool	Whether to call worldedit.marker_update() or not.
-- @returns	nil
local function compat_worldedit_set(player_name, i, pos, do_update)
	if do_update == nil then do_update = false end
	if not worldedit then return end
	if i == 1 and worldedit.pos1 then
		worldedit.pos1[player_name] = nil
		if do_update and worldedit.marker_update then
			worldedit.marker_update(player_name) end
		worldedit.pos1[player_name] = pos:clone()
	elseif i == 2 and worldedit.pos2 then
		worldedit.pos2[player_name] = nil
		if do_update and worldedit.marker_update then
			worldedit.marker_update(player_name) end
		worldedit.pos2[player_name] = pos:clone()
	end
end

--- Fetches pos1/pos2 from WorldEdit (if available) and sets them in WorldEditAdditions' postional subsystem
-- @param	player_name		string	The name of the player to sync the positions for.
local function compat_worldedit_get(player_name)
	compat_worldedit_pos1_get(player_name)
	compat_worldedit_pos2_get(player_name)
end

--- Gets the position with the given index for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @param	i				number	The index of the position to fetch.
-- @returns	Vector3?		The position requested, or nil if it doesn't exist.
local function get(player_name, i)
	ensure_player(player_name)
	if i == 2 then compat_worldedit_pos1_get(player_name)
	elseif i == 2 then compat_worldedit_pos2_get(player_name) end
	
	return positions[player_name][i]
end

--- Convenience function that returns position 1 for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	Vector3?		The position requested, or nil if it doesn't exist.
local function get1(player_name) return get(player_name, 1) end
--- Convenience function that returns position 1 for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	Vector3?		The position requested, or nil if it doesn't exist.
local function get2(player_name) return get(player_name, 2) end

--- Gets a list of all the positions for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	Vector3[]		A list of positions for the given player.
local function get_all(player_name)
	ensure_player(player_name)
	compat_worldedit_pos1_get(player_name)
	compat_worldedit_pos2_get(player_name)
	
	return wea_c.table.deepcopy(positions[player_name])
end

--- Get a bounding box that encloses all the positions currently defined by a given player.
-- @param	player_name		string	The name of the player to fetch the boudnign box for.
-- @returns nil|(Vector3,Vector3)	2 positions that define opposite corners of a region that fully encloses all the defined points for the given player, or nil ir the specified player has no points currently defined.
local function get_bounds(player_name)
	ensure_player(player_name)
	compat_worldedit_pos1_get(player_name)
	compat_worldedit_pos2_get(player_name)
	if #positions[player_name] < 1 then return nil end
	local pos1, pos2 = positions[player_name][1], positions[player_name][1]
	
	for _, pos in pairs(positions[player_name]) do
		pos1, pos2 = Vector3.expand_region(pos, pos1, pos2)
	end
	
	return pos1, pos2
end


--- Counts the number of positioons registered to a given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	number			The number of positions registered for the given player.
local function count(player_name)
	ensure_player(player_name)
	compat_worldedit_pos1_get(player_name)
	compat_worldedit_pos2_get(player_name)
	
	return #positions[player_name]
end
--- Sets the position at the given index for the given player.
-- You probably want push_pos, not this function.
-- @param	player_name		string	The name of the player to set the position for.
-- @param	i				number	The index to set the position at.
-- @param	pos				Vector3	The position to set.
-- @returns	bool			Whether the operation was successful or not (players aren't allowed more than positions_count_limit number of positions at a time).
local function set(player_name, i, pos)
	-- It's a shame that Lua doesn't have a throw/raise, 'cause we could sure use it here
	if i > positions_count_limit then return false end
	ensure_player(player_name)
		
	positions[player_name][i] = pos
	compat_worldedit_set(player_name, i, pos)
	
	anchor:emit("set", { player_name = player_name, i = i, pos = pos })
	return true
end

--- Convenience function that set position 1 for the given player.
-- @param	player_name		string		The name of the player to set pos1 for.
-- @param	pos				Vector3?	The new Vector3 for pos1 to set.
-- @returns	bool			Whether the operation was successful or not, but in this case will always return true so can be ignored.
local function set1(player_name, pos)
	return set(player_name, 1, pos)
end
--- Convenience function that set position 2 for the given player.
-- @param	player_name		string		The name of the player to set pos1 for.
-- @param	pos				Vector3?	The new Vector3 for pos2 to set.
-- @returns	bool			Whether the operation was successful or not, but in this case will always return true so can be ignored.
local function set2(player_name, pos)
	return set(player_name, 2, pos)
end


--- Sets the all the positions for the given player.
-- You probably want push_pos, not this function.
-- @param	player_name		string	The name of the player to set the positions for.
-- @param	pos_list		Vector3	The table of positions to set.
-- @returns	bool			Whether the operation was successful or not (players aren't allowed more than positions_count_limit number of positions at a time).
local function set_all(player_name, pos_list)
	if #pos_list > positions_count_limit then return false end
	positions[player_name] = pos_list
	for i,pos_new in ipairs(positions[player_name]) do
		compat_worldedit_set(player_name, i, pos_new)
		anchor:emit("push", { player_name = player_name, pos = pos_new, i = i })
	end
	return true
end
--- Clears all the positions for the given player.
-- @param	player_name		string	The name of the player to clear the positions for.
-- @returns	void
local function clear(player_name)
	if positions[player_name] then
		positions[player_name] = nil
	end
	if worldedit then
		if worldedit.pos1 then worldedit.pos1[player_name] = nil end
		if worldedit.pos2 then worldedit.pos2[player_name] = nil end
		if worldedit.set_pos then worldedit.set_pos[player_name] = nil end
	end
	anchor:emit("clear", { player_name = player_name })
end
--- Removes the last position from the for a given player and returns it.
-- @param	player_name		string	The name of the player to pop the position for.
-- @returns	Vector3?		The position removed, or nil if it doesn't exist.
local function pop(player_name)
	ensure_player(player_name)
	if #positions[player_name] <= 0 then return nil end
	local pos_count = #positions[player_name]
	local last_pos = table.remove(positions[player_name])
	if worldedit then
		if pos_count == 2 and worldedit.pos2 then worldedit.pos2[player_name] = nil
		elseif pos_count == 1 and worldedit.pos1 then
			worldedit.pos1[player_name] = nil
			worldedit.marker_update(player_name)
		end
	end
	
	anchor:emit("pop", { player_name = player_name, pos = last_pos, i = pos_count })
	return last_pos
end
--- Adds a position to the list for a given player.
-- @param	player_name		string	The name of the player to add the position for.
-- @param	pos				Vector3	The position to add.
-- @returns	number			The new number of positions for that player.
local function push(player_name, pos)
	ensure_player(player_name)
	table.insert(positions[player_name], pos)
	compat_worldedit_set(player_name, #positions[player_name], pos)
	
	anchor:emit("push", { player_name = player_name, pos = pos, i = #positions[player_name] })
	return #positions[player_name]
end

--- Hides the visual markers for the given player's positions and defined region, but does not clear the points.
-- @param	player_name		string	The name of the player to operate on.
-- @param	markers=true	bool	Whether to hide positional markers.
-- @param	walls=true		bool	Whether to hide the marker walls.
-- @returns	void
local function unmark(player_name, markers, walls)
	if markers == nil then markers = true end
	if walls == nil then walls = true end

	anchor:emit("unmark", {
		player_name = player_name,
		markers = markers,
		walls = walls
	})
end

--- Shows the visual markers for the given player's positions and defined region once more.
-- Often used some time after calling worldeditadditions_core.pos.unmark().
-- @param	player_name		string	The name of the player to operate on.
-- @returns	void
local function mark(player_name)
	anchor:emit("mark", {
		player_name = player_name
	})
end

anchor = wea_c.EventEmitter.new({
	get = get,
	get1 = get1,
	get2 = get2,
	get_all = get_all,
	get_bounds = get_bounds,
	count = count,
	clear = clear,
	pop = pop,
	push = push,
	set = set,
	set1 = set1,
	set2 = set2,
	set_all = set_all,
	unmark = unmark,
	mark = mark,
	compat_worldedit_get = compat_worldedit_get,
})
anchor.debug = false

return anchor
