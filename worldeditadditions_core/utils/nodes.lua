--- Makes an associative table of node_name => weight into a list of node ids.
-- Node names with a higher weight are repeated more times.
function worldeditadditions.make_weighted(tbl)
	local result = {}
	for node_name, weight in pairs(tbl) do
		local next_id = minetest.get_content_id(node_name)
		-- print("[make_weighted] seen "..node_name.." @ weight "..weight.." → id "..next_id)
		for i = 1, weight do
			table.insert(result, next_id)
		end
	end
	return result, #result
end

--- Unwinds a list of { node = string, weight = number } tables into a list of node ids.
-- The node ids will be repeated multiple times according to their weights
-- (e.g. an entry with a weight of 2 will be repeated twice).
-- @param	list		table[]		The list to unwind.
-- @return	number[],number			The unwound list of node ids, follows by the number of node ids in total.
function worldeditadditions.unwind_node_list(list)
	local result = {}
	for i,item in ipairs(list) do
		local node_id = minetest.get_content_id(item.node)
		for _i = 1, item.weight do
			table.insert(result, node_id)
		end
	end
	return result, #result
end

function worldeditadditions.registered_nodes_by_group(group)
	local result = {}
	for name, def in pairs(minetest.registered_nodes) do
		if def.groups[group] then
			result[#result+1] = name
		end
	end
	return result
end

--- Turns a node_name → weight table into a list of { node_name, weight } tables.
function worldeditadditions.weighted_to_list(node_weights)
	local result = {}
	for node_name, weight in pairs(node_weights) do
		table.insert(result, { node_name, weight })
	end
	return result
end


local function emerge_callback(pos, action, num_calls_remaining, state)
	if not state.total then
		state.total = num_calls_remaining + 1
		state.loaded_blocks = 0
	end
	
	state.loaded_blocks = state.loaded_blocks + 1
	
	if state.loaded_blocks == state.total then
		state.callback(state, state.callback_state)
	else
		if action == minetest.EMERGE_CANCELLED then
			state.stats.cancelled = state.stats.cancelled + 1
		elseif action == minetest.EMERGE_ERRORED then
			state.stats.error = state.stats.error + 1
		elseif action == minetest.EMERGE_FROM_MEMORY then
			state.stats.from_memory = state.stats.from_memory + 1
		elseif action == minetest.EMERGE_FROM_DISK then
			state.stats.from_disk = state.stats.from_disk + 1
		elseif action == minetest.EMERGE_GENERATED then
			state.stats.generated = state.stats.generated + 1
		end
	end
end

--- Loads the area defined by the specified region using minetest.emerge_area.
-- Unlike minetest.emerge_area, this command calls the specified callback only
-- once upon completion.
-- @param	{Vector}	pos1		The first position defining the area to emerge.
-- @param	{Vector}	pos2		The second position defining the area to emerge.
-- @param	{function}	callback	The callback to call when the emerging process is complete.
-- @param	{any}		callback_state	A state object to pass to the callback as a 2nd parameter (the 1st parameter is the emerge_area progress tracking state object)
function worldeditadditions.emerge_area(pos1, pos2, callback, callback_state)
	local state = {
		stats = { cancelled = 0, error = 0, from_memory = 0, from_disk = 0, generated = 0 },
		callback = callback,
		callback_state = callback_state
	}
	minetest.emerge_area(pos1, pos2, emerge_callback, state)
end
