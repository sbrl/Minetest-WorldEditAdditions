
--- Turns an associative node_id → count table into a human-readable list.
-- @param	distribution	table	A node distribution in the format { node_name = count, .... }.
-- @param	nodes_total		number	The total number of nodes in the distribution.
-- @param	add_total		bool	Whether to add a grand total to the bottom or not. Default: no
function worldeditadditions.format.node_distribution(distribution, nodes_total, add_total)
	local distribution_data = {}
	for node_id, count in pairs(distribution) do
		table.insert(distribution_data, {
			count,
			tostring(worldeditadditions.round((count / nodes_total) * 100, 2)).."%",
			minetest.get_name_from_content_id(node_id)
		})
	end
	local result = worldeditadditions.format.make_ascii_table(distribution_data)
	
	if add_total == true then
		result = result.."\n"..string.rep("=", 6 + #tostring(nodes_total) + 6).."\n"..
		"Total "..nodes_total.." nodes\n"
	end
	
	return result
end
