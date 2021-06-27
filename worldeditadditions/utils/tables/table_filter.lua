--- Filters the items in the given table using the given function.
-- The function is executed for each item in the list. If it returns true, the
-- item is kept. If it returns false, the item is discarded.
-- Arguments passed to the function: item, i
-- ...where item is the item to filter, and i is the index in the table the item
-- is located at.
-- @param	tbl		table		The table of values to filter.
-- @param	func	function<any, number>:bool	The filter function to execute - should return a boolean value indicating whether the item provided as the first argument should be kept
-- @returns	table	A new table containing the values that the given function returned true for.
local function table_filter(tbl, func)
	local result = {}
	for i,value in ipairs(tbl) do
		if func(value, i) then
			table.insert(result, value)
		end
	end
	return result
end

return table_filter
