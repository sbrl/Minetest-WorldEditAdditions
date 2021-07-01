--- Returns the key value pairs in a table as a single string
-- @param	tbl	table	input table
-- @param	sep	string	key value seperator
-- @param	new_line	string	key value pair delimiter
-- @return	string	concatenated table pairs
local function table_tostring(tbl, sep, new_line)
	if type(sep) ~= "string" then sep = ": " end
	if type(new_line) ~= "string" then new_line = ", " end
	local ret = {}
	if type(tbl) ~= "table" then return "Error: input not table!" end
	for key,value in pairs(tbl) do
		table.insert(ret,tostring(key) .. sep .. tostring(value) .. new_line)
	end
	return table.concat(ret,"")
end

return table_tostring
