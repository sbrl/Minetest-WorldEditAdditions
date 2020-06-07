--- Makes an associative table of node_name => weight into a list of node ids.
-- Node names with a heigher weight are repeated more times.
function worldeditadditions.make_weighted(tbl)
	local result = {}
	for node_name, weight in pairs(tbl) do
		local next_id = minetest.get_content_id(node_name)
		print("[make_weighted] seen "..node_name.." @ weight "..weight.." → id "..next_id)
		for i = 1, weight do
			table.insert(
				result,
				next_id
			)
		end
	end
	return result, #result
end
