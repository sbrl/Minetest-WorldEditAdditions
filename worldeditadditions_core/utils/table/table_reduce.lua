

--- Lua implementation of array.reduce() from Javascript.
-- @param	tbl				The table to iterate over.
-- @param	func			The function to call for every element in tbl. Will be passed the following arguments: accumulator, value, index, table. Of course, the provided function need not take this many arguments.
-- @param	initial_value	The initial value of the accumulator.
local function table_reduce(tbl, func, initial_value)
	local acc = initial_value
	for key, value in pairs(tbl) do
		acc = func(acc, value, key, tbl)
	end
	return acc
end

return table_reduce
