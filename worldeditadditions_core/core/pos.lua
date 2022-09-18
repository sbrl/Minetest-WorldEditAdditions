local wea_c = worldeditadditions_core

local positions_count_limit = 999
local positions = {}

local function ensure_player(player_name)
	if not positions[player_name] then
		positions[player_name] = {}
	end
end

--- Gets the position with the given index for the given player.
-- @param	player_name		string	The name of the player to fetch the position for.
-- @param	
local function get_pos(player_name, i)
	ensure_player(player_name)
	return positions[player_name][i]
end

local function get_pos1(player_name) return get_pos(player_name, 1) end
local function get_pos2(player_name) return get_pos(player_name, 2) end

local function get_pos_all(player_name)
	ensure_player(player_name)
	return positions[player_name]
end
local function pos_count(player_name)
	ensure_player(player_name)
	return #pos_count[player_name]
end

local function set_pos(player_name, i, pos)
	if i > positions_count_limit then return false end
	ensure_player(player_name)
	positions[player_name][i] = pos
	return true
end
local function set_pos_all(player_name, i, pos_list)
	if #pos_list > positions_count_limit then return false end
	positions[player_name] = pos_list
end
local function clear(player_name)
	if positions[player_name] then
		positions[player_name] = nil
	end
end

return {
	get = get_pos,
	get1 = get_pos1,
	get2 = get_pos2,
	get_all = get_pos_all,
	set = set_pos,
	set_all = set_pos_all,
	count = pos_count,
	clear = clear
}