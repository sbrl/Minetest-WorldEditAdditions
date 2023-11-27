local weac = worldeditadditions_core
local table_map = dofile(weac.modpath.."/utils/table/table_map.lua")

--- Matcherer that compares node ids to given list of node names.
-- This is a class so that caching can be done locally and per-task.
-- @class	worldeditadditions_core.NodeListMatcher
local NodeListMatcher = {}
NodeListMatcher.__index = NodeListMatcher
NodeListMatcher.__name = "NodeListMatcher" -- A hack to allow identification in wea.inspect

local node_names_special = {
	airlike = function(node_id)
		return weac.is_airlike(node_id)
	end,
	liquidlike = function(node_id)
		return weac.is_liquidlike(node_id)
	end
}

--- Parses a list of node names, accounting for special keywords and group names.
-- @param	nodelist	string[]	The list of nodes to parse.
-- @returns	bool,string|table<string|function|number>	A success bool (true = success), followed by eitheran error string if success == false or the parsed nodelist if success == true.
-- 
-- Different data types in the parsed nodelist mean different things:
-- 
-- - **string:** The name of a group
-- - **function:** A special function to call with the node id to match against as the first and only argument.
-- - **number:** The id of the node to check against.
local function __parse_nodelist(nodelist)
	local failed_msg = nil
	local parsed = table_map(nodelist, function(node_name)
		-- 1: match against defined special keywords
		if node_names_special[node_name] ~= nil then
			return node_names_special[node_name]
		end
		-- 2: Is it a group name? Group names start with an at sign @.
		if node_name:sub(1, 1) == "@" then
			return node_name:sub(2)
		end
		
		-- 3: It's probably a node name then.
		local node_id = minetest.get_content_id(node_name)
		if node_id == nil then failed_msg = "Error: Failed to resolve node name '"..node_name.."' to a node id. This is probably a bug. Did you remember to normalise the input node names?" end
		
		return node_id
	end)
	
	if failed_msg ~= nil then return false, failed_msg end
	return true, parsed
end

--- Creates a new NodeListMatcher instance with the given node list.
-- Once created, you probably want to call the :match_id(node_id) function.
-- @param	nodelist	string[]	The list of nodes to match against.
-- 
-- `airlike` and `liquidlike` are special keywords that instead check if a given node id behaves like air or a liquid respectively.
-- 
-- Node names prefixed with an at sign (@) are considered group names, and given node ids are checked for membership of the given group.
-- @returns	bool,string|NodeListMatcher			A success bool (true == success), and then either a string (if succes == false) or otherwise the newly created NodeListMatcher instance.
function NodeListMatcher.new(nodelist)
	local success, nodelist_parsed = __parse_nodelist(nodelist)
	if not success then return success, nodelist_parsed end
	
	local result = {
		-- The parsed nodelist
		nodelist = nodelist_parsed,
		-- The group cache, since node id → group membership checking requires 2 minetest.* calls.
		groupcache = {}
	}
	setmetatable(result, NodeListMatcher)
	return true, result
end

--- Matches the given node id against the nodelist provided at the instantiation of this NodeListMatcher instance.
-- Returns true if the given node_id matches against any one of the items in the nodelist. In other words, performs a logical OR operation.
-- 
-- We use the term 'item' and not 'node' here since not all items in the nodelist are nodes: nodelists support special keywords such as 'liquidlike' and 'airlike', as well as group names (prefixed with an at sign @).
-- @param	matcher		NodeListMatcher		The NodeListMatcher instance to query against. Use some_matcher:match_id(node_id) to avoid specifying this manually (note the colon : and not a dot . there).
-- @param	node_id		number				The numerical id of the node to match against the internal nodelist.
-- @returns	bool		True if the given node id matches against any of the items in the nodelist.
function NodeListMatcher.match_id(matcher, node_id)
	print("DEBUG matcher", weac.inspect(matcher))
	for i,target in ipairs(matcher.nodelist) do
		local target_type = type(target)
		if target_type == "number" then
			-- It's a node id!
			if target == node_id then return true end
		elseif target_type == "function" then
			-- It's a special function!
			local result = target(node_id)
			if result then return true end
		elseif target_type == "string" then
			local result = matcher:match_group(node_id, target)
			if result then return true end
		end
	end
	return false
end

--- Determines if the given node id has the given group name.
-- Caches the result for performance. You probably want NodeListMatcher:match_id(node_id).
-- @param	matcher		NodeListMatcher		The NodeListMatcher instance to use to make the query.
-- @param	node_id		number				The numerical id of the node to check.
-- @param	group_name	string				The name of the group to check if the given node id has.
-- @returns	bool		True if the given node id belongs to the specified group, and false if it does not.
function NodeListMatcher.match_group(matcher, node_id, group_name)
	-- 0: Preamble
	if matcher.groupcache[node_id] == nil then
		matcher.groupcache[node_id] = {}
	end
	
	-- 1: Check the cache
	if matcher.groupcache[node_id][group_name] ~= nil then
		return matcher.groupcache[node_id][group_name]
	end
	
	-- 2: Nope, not in the cache. Time to query!
	local node_name = minetest.get_name_from_content_id(node_id)
	local group_value = minetest.get_item_group(node_name, "group:"..group_name)
	if group_value == 0 then group_value = false
	else group_value = true end
	
	-- 3: Update the cache
	matcher.groupcache[node_id][group_name] = group_value
	
	-- 4: Return the value now it's in the cache
	return group_value
end



return NodeListMatcher