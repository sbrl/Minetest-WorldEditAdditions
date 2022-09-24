
--- Looks to see whether a given table contains a given value.
-- @param	tbl		table	The table to look in.
-- @param	target	any		The target to look for.
-- @returns	bool	Whether the table contains the given target or not.
local function table_contains(tbl, target)
	for key, value in ipairs(tbl) do
		if value == target then return true end
	end
	return false
end

return table_contains
