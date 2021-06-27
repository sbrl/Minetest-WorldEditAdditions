--- Executes the given function on every item in the given table.
-- Ignores return values that are nil and doesn't insert them into the table.
-- @param	tbl		table		The table to operate on.
-- @param	func	function<any>:any|nil	The function to execute on every item in the table.
-- @returns	table	A new table containing the return values of the function.
local function table_map(tbl, func)
	local result = {}
	for i,value in ipairs(tbl) do
		local newval = func(value, i)
		if newval ~= nil then table.insert(result, newval) end
	end
	return result
end

return table_map
