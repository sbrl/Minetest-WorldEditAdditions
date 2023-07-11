local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3



local metaballdata = {}

--- Adds a new metaball for a given player at the specified position with a specified radius.
-- @param	player_name	string	The name of the player.
-- @param	pos			Vector3	The position of the metaball.
-- @param	radius		number	The radius of the metaball.
-- @returns	bool,number	The number of metaballs now defined for the given player.
local function add(player_name, pos, radius)
	pos = Vector3.clone(pos)
	
	if type(player_name) ~= "string" then
		return false, "Error: Invalid player name specified."
	end
	if type(radius) ~= "number" then
		return false, "Error: Expected the radius to be of type number, but got value of type "..type(radius).." instead."
	end
	if radius < 1 then
		return false, "The minimum radius of a metaball is 1, but got a radius of "..tostring(radius).."."
	end
	
	if not metaballdata[player_name] then
		metaballdata[player_name] = {}
	end
	
	-- TODO: Limit the number of metaballs that can be defined?
	table.insert(metaballdata[player_name], {
		pos = pos,
		radius = radius
	})
	
	return true, #metaballdata[player_name]
end

--- Returns a list of all metaballs defined for the given player.
-- @param	player_name	string	The name of the player.
-- @returns	bool,[{ pos: Vector3, radius: number }, ...]	A list of metaballs for the given player.
local function list(player_name)
	if type(player_name) ~= "string" then
		return false, "Error: Invalid player name specified."
	end
	
	if not metaballdata[player_name] then return {} end
	
	return true, metaballdata[player_name]
end

--- Returns a pretty-printed list of metaballs for the given player.
-- @param	player_name	string	The name of the player.
-- @returns	bool,string		A pretty-printed list of metaballs for the given player.
local function list_pretty(player_name)
	local success, metaball_list = list(player_name)
	if not success then return success, metaball_list end
	if not metaball_list or type(metaball_list) ~= "table" then
		return false, "Invalid metaball list returned"
	end
	
	local rows = { { "Index", "Position", "Radius" } }
	for i,metaball in ipairs(metaball_list) do
		table.insert(rows, {
			i,
			metaball.pos,
			metaball.radius
		})
	end
	
	return true, wea_c.format.make_ascii_table(rows).."\n---------------------------\nTotal "..tostring(#metaball_list).." metaballs"
end

--- Removes the metaball with the specified index for a given player.
-- @param	player_name	string	The name of the player.
-- @param	index		number	The index of the metaball to remove.
-- @returns	bool,number	The number of metaballs now defined for the given player.
local function remove(player_name, index)
	local success, metaball_list = list(player_name)
	if not success then return success, metaball_list end
	if not metaball_list or type(metaball_list) ~= "table" then
		return false, "Invalid metaball list returned"
	end
	
	if index > #metaball_list then
		return false, "Error: Requested the removal of metaball "..tostring(index)..", but there are "..tostring(#metaball_list).." metaballs defined."
	end
	
	table.remove(metaball_list, index)
	
	return true, #metaball_list
end

--- Removes all the currently defined metaballs for the given player.
-- @param	player_name	string	The name of the player.
-- @returns	bool,number	The number of metaballs that WERE defined for the given player.
local function clear(player_name)
	local success, metaball_list = list(player_name)
	if not success then return success, metaball_list end
	
	metaballdata[player_name] = {}
	
	return #metaball_list
end

--- Calculates the total volume that the currently defined metaballs are expected to take up.
-- @param	player_name	string	The name of the player.
-- @returns	bool,number	The total volume that the currently defined metaballs are expected to take up.
local function volume(player_name)
	local success, metaball_list = list(player_name)
	if not success then return success, metaball_list end
	
	if not metaball_list or not metaball_list[1] or type(metaball_list) ~= "table" then return false, "Error: Invalid metaball list returned" end
	
	if #metaball_list == 0 then return 0 end
	
	
	local pos1 = metaball_list[1].pos
	local pos2 = pos1
	
	for i,metaball in ipairs(metaball_list) do
		pos1 = Vector3.min(pos1, metaball.pos - metaball.radius)
		pos2 = Vector3.max(pos2, metaball.pos + metaball.radius)
	end
	
	return true, (pos2 - pos1):area()
end

return {
	add = add,
	list = list,
	list_pretty = list_pretty,
	remove = remove,
	clear = clear,
	volume = volume
}
