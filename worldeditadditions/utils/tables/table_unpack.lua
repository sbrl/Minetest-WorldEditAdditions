--- Polyfill for unpack / table.unpack.
-- Calls unpack when available, and looks for table.unpack if unpack() isn't
-- found.
-- This is needed because in Lua 5.1 it's the global unpack(), but in Lua 5.4
-- it's moved to table.unpack().
local function table_unpack(tbl, offset, count)
	if type(unpack) == "function" then
		return unpack(tbl, offset, count)
	else
		return table.unpack(tbl, offset, count)
	end
end

return table_unpack
