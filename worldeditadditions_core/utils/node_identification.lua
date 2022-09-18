local node_id_air = minetest.get_content_id("air")
local node_id_ignore = minetest.get_content_id("ignore")

--- Determines whether the given node/content id is an airlike node or not.
-- It is recommended that the result of this function be cached.
-- @param	id		number	The content/node id to check.
-- @return	bool	Whether the given node/content id is an airlike node or not.
function worldeditadditions.is_airlike(id)
	--  Do a fast check against air and ignore
	if id == node_id_air then
		return true
	elseif id == node_id_ignore then -- ignore = not loaded yet IIRC (so it could be anything)
		return false
	end
	
	-- If the node isn't registered, then it might not be an air node
	if not minetest.registered_nodes[id] then return false end
	if minetest.registered_nodes[id].sunlight_propagates == true then
		return true
	end
	-- Check for membership of the airlike group
	local name = minetest.get_name_from_content_id(id)
	local airlike_value = minetest.get_item_group(name, "airlike")
	if airlike_value ~= nil and airlike_value > 0 then
		return true
	end
	-- Just in case
	if worldeditadditions.str_starts(name, "wielded_light") then
		return true
	end
	-- Just in case
	return false
end

--- Determines whether the given node/content id is a liquid-ish node or not.
-- It is recommended that the result of this function be cached.
-- @param	id		number	The content/node id to check.
-- @return	bool	Whether the given node/content id is a liquid-ish node or not.
function worldeditadditions.is_liquidlike(id)
	-- print("[is_liquidlike]")
	if id == node_id_ignore then return false end
	
	local node_name = minetest.get_name_from_content_id(id)
	if node_name == nil or not minetest.registered_nodes[node_name] then return false end
	
	local liquidtype = minetest.registered_nodes[node_name].liquidtype
	-- print("[is_liquidlike]", "id", id, "name", node_name, "liquidtype", liquidtype)
	
	if liquidtype == nil or liquidtype == "none" then return false end
	-- If it's not none, then it has to be a liquid as the only other values are source and flowing
	return true
end

--- Determines whether the given node/content id is a sapling or not.
-- Nodes with the "sapling" group are considered saplings.
-- It is recommended that the result of this function be cached.
-- @param	id		number	The content/node id to check.
-- @return	bool	Whether the given node/content id is a sapling or not.
function worldeditadditions.is_sapling(id)
	local node_name = minetest.get_name_from_content_id(id)
	return minetest.get_item_group(node_name, "sapling") ~= 0
end


-- ███████  █████  ██████  ██      ██ ███    ██  ██████
-- ██      ██   ██ ██   ██ ██      ██ ████   ██ ██
-- ███████ ███████ ██████  ██      ██ ██ ██  ██ ██   ███
--      ██ ██   ██ ██      ██      ██ ██  ██ ██ ██    ██
-- ███████ ██   ██ ██      ███████ ██ ██   ████  ██████
-- 
--  █████  ██      ██  █████  ███████ ███████ ███████
-- ██   ██ ██      ██ ██   ██ ██      ██      ██
-- ███████ ██      ██ ███████ ███████ █████   ███████
-- ██   ██ ██      ██ ██   ██      ██ ██           ██
-- ██   ██ ███████ ██ ██   ██ ███████ ███████ ███████


local sapling_aliases = {}

--- Register a new sapling alias.
-- @param	sapling_node_name	string		The canonical name of the sapling.
-- @param	alias				string		The alias name of the sapling.
-- @returns	bool[,string]		Whether the alias registration was successful or not. If false, then an error message as a string is also returned as the second value.
function worldeditadditions.register_sapling_alias(sapling_node_name, alias)
	if sapling_aliases[sapling_node_name] ~= nil then
		return false, "Error: An alias against the node name '"..sapling_node_name.."' already exists."
	end
	sapling_aliases[alias] = sapling_node_name
	return true
end
--- Convenience function to register many sapling aliases at once.
-- @param	tbl	[string, string][]	A list of tables containing exactly 2 strings in the form { sapling_node_name, alias }.
-- @returns	bool[,string]		Whether the alias registrations were successful or not. If false, then an error message as a string is also returned as the second value.
function worldeditadditions.register_sapling_alias_many(tbl)
	for i, next in ipairs(tbl) do
		local success, msg = worldeditadditions.register_sapling_alias(
			next[1],
			next[2]
		)
		if not success then return success, msg end
	end
	return true
end
--- Returns the current key ⇒ value table of sapling names and aliases.
-- @return	table
function worldeditadditions.get_all_sapling_aliases()
	return sapling_aliases
end

--- Attempts to normalise a sapling name using the currently registered aliases.
-- @param	in_name					string	The sapling name  to normalise
-- @param	return_nil_on_failure	bool	Whether to return nil if we fail to resolve the sapling name with an alias, or return the original node name instead (default: false).
function worldeditadditions.normalise_saplingname(in_name, return_nil_on_failure)
	if sapling_aliases[in_name] then return sapling_aliases[in_name]
	elseif return_nil_on_failure then return nil
	else return in_name end
end
