--- Builds a new table with the elements of the given table appearing at most once.
-- @param	tbl		table	The table of values to make unique.
-- @returns	table	A new table containing the values of the given table appearing at most once.
local function table_unique(tbl)
	local newtbl = {}
	for i,value in ipairs(tbl) do
		local seen = false
		for j,seenvalue in ipairs(newtbl) do
			if value == seenvalue then
				seen = true
				break
			end
		end
		if not seen then
			table.insert(newtbl, value)
		end
	end
	return newtbl
end

return table_unique
