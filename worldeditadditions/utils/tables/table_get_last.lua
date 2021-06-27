local wea = worldeditadditions

local table_unpack = dofile(wea.modpath.."/utils/tables/table_unpack.lua")


--- Returns only the last count items in a given numerical table-based list.
-- @param	tbl		table		The table to fetch items from.
-- @param	count	number		The number of items to fetch from the end of the table.
-- @returns	table	A table containing the last count items from the given table.
local function table_get_last(tbl, count)
	return {table_unpack(
		tbl,
		math.max(0, (#tbl) - (count - 1))
	)}
end

return table_get_last
