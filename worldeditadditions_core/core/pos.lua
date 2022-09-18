local wea_c = worldeditadditions_core

local positions_count_limit = 999
local positions = {}
local anchor = nil

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
	return #positions[player_name]
end

local function set_pos(player_name, i, pos)
	if i > positions_count_limit then return false end
	ensure_player(player_name)
	positions[player_name][i] = pos
	anchor:emit("set", { i = i, pos = pos })
	return true
end
local function set_pos_all(player_name, i, pos_list)
	if #pos_list > positions_count_limit then return false end
	positions[player_name] = pos_list
	for _i,pos_new in ipairs(positions[player_name]) do
		anchor:emit("push", { pos = pos_new })
	end
end
local function clear(player_name)
	if positions[player_name] then
		positions[player_name] = nil
	end
	anchor:emit("clear")
end
local function pop_pos(player_name)
	ensure_player(player_name)
	if #positions[player_name] <= 0 then return nil end
	local last_pos = table.remove(positions[player_name])
	anchor:emit("pop", { pos = last_pos })
	return last_pos
end
local function push_pos(player_name, pos)
	ensure_player(player_name)
	table.insert(positions[player_name], pos)
	anchor:emit("push", { pos = pos })
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
