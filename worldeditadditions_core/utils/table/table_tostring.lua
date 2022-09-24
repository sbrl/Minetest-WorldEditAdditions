--- Returns the key value pairs in a table as a single string
-- @param	tbl	table	input table
-- @param	sep	string	key value seperator
-- @param	new_line	string	key value pair delimiter
-- @param	max_depth	number	max recursion depth (optional)
-- @return	string	concatenated table pairs
local function table_tostring(tbl, sep, new_line, max_depth)
	if type(sep) ~= "string" then sep = ": " end
	if type(new_line) ~= "string" then new_line = ", " end
	if type(max_depth) == "number" then max_depth = {depth=0,max=max_depth}
	elseif type(max_depth) ~= "table" then max_depth = {depth=0,max=5} end
	local ret = {}
	if type(tbl) ~= "table" then return "Error: input not table!" end
	for key,value in pairs(tbl) do
		if type(value) == "table" and max_depth.depth < max_depth.max then
			table.insert(ret,tostring(key) .. sep ..
			"{" .. table_tostring(value,sep,new_line,{max_depth.depth+1,max_depth.max}) .. "}")
		else
			table.insert(ret,tostring(key) .. sep .. tostring(value))
		end
	end
	return table.concat(ret,new_line)
end

-- Test:
-- /lua v1 = { x= 0.335, facing= { axis= "z", sign= -1 } }; print(worldeditadditions.table.tostring(v1))

return table_tostring
