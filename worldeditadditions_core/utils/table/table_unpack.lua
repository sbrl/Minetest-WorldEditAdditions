---
-- @module worldeditadditions_core.table

--- Polyfill for unpack / table.unpack.
-- Calls unpack when available, and looks for table.unpack if unpack() isn't
-- found.
-- This is needed because in Lua 5.1 it's the global unpack(), but in Lua 5.4
-- it's moved to table.unpack().
--
-- Important: All unpack calls in WorldEditAdditions **MUST** use this function.
-- @param	tbl			table	The table to unpack
-- @param	[offset=0]	number	The offset at which to start unpacking.
-- @param	[count=nil]	number	The number of items to unpack. Defaults to unpack all remaining items after `offset`.
-- @returns any...		The selected items unpacked from the table.
local function table_unpack(tbl, offset, count)
	---@diagnostic disable-next-line: deprecated
	if type(unpack) == "function" then
		---@diagnostic disable-next-line: deprecated
		return unpack(tbl, offset, count)
	else
		return table.unpack(tbl, offset, count)
	end
end

return table_unpack
