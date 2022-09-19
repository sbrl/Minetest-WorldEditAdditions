local wea_c = worldeditadditions_core

local positions_count_limit = 999
local positions = {}

--- Position manager.
-- @event	set		{ player_name: string, i: number, pos: Vector3 }	A new position has been set in a player's list at a specific position.
-- @event	push	{ player_name: string, i: number, pos: Vector3 }	A new position has been pushed onto a player's stack.
-- @event	pop		{ player_name: string, i: number, pos: Vector3 }	A new position has been pushed onto a player's stack.
-- @event	clear	{ player_name: string }	The positions for a player have been cleared.
local anchor = nil

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

--- Gets the position with the given index for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @param	i				number	The index of the position to fetch.
-- @returns	Vector3?		The position requested, or nil if it doesn't exist.
local function get_pos(player_name, i)
	ensure_player(player_name)
	return positions[player_name][i]
end

--- Convenience function that returns position 1 for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	Vector3?		The position requested, or nil if it doesn't exist.
local function get_pos1(player_name) return get_pos(player_name, 1) end
--- Convenience function that returns position 1 for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	Vector3?		The position requested, or nil if it doesn't exist.
local function get_pos2(player_name) return get_pos(player_name, 2) end

--- Gets a list of all the positions for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	Vector3[]		A list of positions for the given player.
local function get_pos_all(player_name)
	ensure_player(player_name)
	return wea_c.table.deepcopy(positions[player_name])
end
--- Counts the number of positioons registered to a given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @returns	number			The number of positions registered for the given player.
local function pos_count(player_name)
	ensure_player(player_name)
	return #positions[player_name]
end
--- Sets the position at the given index for the given player.
-- You probably want push_pos, not this function.
-- @param	player_name		string	The name of the player to set the position for.
-- @param	i				number	The index to set the position at.
-- @param	pos				Vector3	The position to set.
-- @returns	bool			Whether the operation was successful or not (players aren't allowed more than positions_count_limit number of positions at a time).
local function set_pos(player_name, i, pos)
	if i > positions_count_limit then return false end
	ensure_player(player_name)
	positions[player_name][i] = pos
	anchor:emit("set", { player_name = player_name, i = i, pos = pos })
	return true
end
--- Sets the all the positions for the given player.
-- You probably want push_pos, not this function.
-- @param	player_name		string	The name of the player to set the positions for.
-- @param	pos_list		Vector3	The table of positions to set.
-- @returns	bool			Whether the operation was successful or not (players aren't allowed more than positions_count_limit number of positions at a time).
local function set_pos_all(player_name, pos_list)
	if #pos_list > positions_count_limit then return false end
	positions[player_name] = pos_list
	for i,pos_new in ipairs(positions[player_name]) do
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
	anchor:emit("clear", { player_name = player_name })
end
--- Removes the last position from the for a given player and returns it.
-- @param	player_name		string	The name of the player to pop the position for.
-- @returns	Vector3?		The position removed, or nil if it doesn't exist.
local function pop_pos(player_name)
	ensure_player(player_name)
	if #positions[player_name] <= 0 then return nil end
	local count = #positions[player_name]
	local last_pos = table.remove(positions[player_name])
	anchor:emit("pop", { player_name = player_name, pos = last_pos, i = count })
	return last_pos
end
--- Adds a position to the list for a given player.
-- @param	player_name		string	The name of the player to add the position for.
-- @param	pos				Vector3	The position to add.
-- @returns	number			The new number of positions for that player.
local function push_pos(player_name, pos)
	ensure_player(player_name)
	table.insert(positions[player_name], pos)
	anchor:emit("push", { player_name = player_name, pos = pos, i = #positions[player_name] })
	return #positions[player_name]
end


anchor = wea_c.EventEmitter.new({
	get = get_pos,
	get1 = get_pos1,
	get2 = get_pos2,
	get_all = get_pos_all,
	count = pos_count,
	clear = clear,
	pop = pop_pos,
	push = push_pos,
	set = set_pos,
	set_all = set_pos_all
})

return anchor
