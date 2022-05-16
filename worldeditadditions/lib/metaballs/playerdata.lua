local wea = worldeditadditions
local Vector3 = wea.Vector3

local metaballdata = {}

--- Adds a new metaball for a given player at the specified position with a specified radius.
-- @param	player_name	string	The name of the player.
-- @param	pos			Vector3	The position of the metaball.
-- @param	radius		number	The radius of the metaball.
-- @returns	bool,number	The number of metaballs now defined for the given player.
local function add(player_name, pos, radius)
	local pos = Vector3.clone(pos)
	
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
	
	local rows = { { "Index", "Position", "Radius" } }
	for i,metaball in ipairs(metaball_list) do
		table.insert(rows, {
			i,
			metaball.pos,
			metaball.radius
		})
	end
	
	return true, wea.format.make_ascii_table(rows).."\n---------------------------\nTotal "..tostring(#metaball_list).." metaballs"
end

--- Removes the metaball with the specified index for a given player.
-- @param	player_name	string	The name of the player.
-- @param	index		number	The index of the metaball to remove.
-- @returns	bool,number	The number of metaballs now defined for the given player.
local function remove(player_name, index)
	local success, metaball_list = list(player_name)
	if not success then return success, metaball_list end
	
	if #metaball_list > index then
		return false, "Error: Requested the removal of metaball "..tostring(index)..", but there are "..tostring(#metaball_list).." metaballs defined."
	end
	
	table.remove(metaball_list, index)
	
	return #metaball_list
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

return {
	add = add,
	list = list,
	list_pretty = list_pretty,
	remove = remove,
	clear = clear
}
