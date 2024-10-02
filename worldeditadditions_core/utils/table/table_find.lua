---
-- @module worldeditadditions_core.table

--- Finds the first element in the given table that satisfies the given testing function.
-- A port of Javascript's `array.find` to Lua.
-- 
-- Uses for .. in ipairs() under-the-hood.
-- 
-- @param	tbl		table		The table to search.
-- @param	func	function	The testing function to call on each element. The function should return true/false as to whether the passed value passes the test function. The testing function will be provided with the following arguments:
-- 1. `value` (any): The value being inspected.
-- 2. `i` (number): The index in the table that the value can be found at
-- 3. `tbl` (table): The original table.
-- @return any|nil The first element in the table that satisfies the predicate, or nil if no such element is found.
local function find(tbl, func)
	for i,value in ipairs(tbl) do
		if func(value, i, tbl) then
			return value
		end
	end
end

return find