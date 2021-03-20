
--- Makes a human-readable table of data.
-- Data should be a 2D array - i.e. a table of tables. The nested tables should
-- contain a list of items for a single row.
-- If total is specified, then a grand total is printed at the bottom - this is
-- useful when you want to print a node list.
-- @param	data	table[]	A table of tables. Each subtable is a single row of the tabulated output.
-- @returns	string	The input table of tables formatted into a nice ASCII table.
function worldeditadditions.format.make_ascii_table(data)
	local extra_padding = 2
	local result = {}
	local max_lengths = {}
	for y = 1, #data, 1 do
		for x = 1, #data[y], 1 do
			if not max_lengths[x] then
				max_lengths[x] = 0
			end
			max_lengths[x] = math.max(max_lengths[x], #tostring(data[y][x]) + extra_padding)
		end
	end
		
	for _key, row in ipairs(data) do
		local row_result = {}
		for i = 1, #row, 1 do
			row_result[#row_result + 1] = worldeditadditions.str_padend(tostring(row[i]), max_lengths[i], " ")
		end
		result[#result+1] = table.concat(row_result, "")
	end
	
	-- TODO: Add multi-column support here
	return table.concat(result, "\n")
end
