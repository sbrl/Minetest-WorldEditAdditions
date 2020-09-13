--- Makes an associative table of node_name => weight into a list of node ids.
-- Node names with a heigher weight are repeated more times.
function worldeditadditions.make_weighted(tbl)
	local result = {}
	for node_name, weight in pairs(tbl) do
		local next_id = minetest.get_content_id(node_name)
		print("[make_weighted] seen "..node_name.." @ weight "..weight.." → id "..next_id)
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
		for i = 1, item.weight do
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
