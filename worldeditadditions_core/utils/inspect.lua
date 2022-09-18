--- Serialises an arbitrary value to a string.
-- Note that although the resulting table *looks* like valid Lua, it isn't.
-- Completely arbitrarily, if a table (or it's associated metatable) has the
-- key __name then it is conidered the name of the parent metatable. This can
-- be useful for identifying custom table-based types.
-- Should anyone come across a 'proper' way to obtain the name of a metatable
-- in pure vanilla Lua, I will update this to follow that standard instead.
-- @param	item		any		Input item to serialise.
-- @param	sep			string	key value seperator
-- @param	new_line	string	key value pair delimiter
-- @return	string	concatenated table pairs
local function inspect(item, maxdepth)
	if not maxdepth then maxdepth = 3 end
	if type(item) ~= "table" then
		if type(item) == "string" then return "\""..item.."\"" end
		return tostring(item)
	end
	if maxdepth < 1 then return "[truncated]" end
	
	local result = {  }
	-- Consider our (arbitrarily decided) property __name to the type of this item
	-- Remember that this implicitly checks the metatable so long as __index is set.
	if type(item.__name) == "string" then
		table.insert(result, "("..item.__name..") ")
	end
	table.insert(result, "{\n")
	for key,value in pairs(item) do
		local value_text = inspect(value, maxdepth - 1)
			:gsub("\n", "\n\t")
		table.insert(result, "\t"..tostring(key).." = ".."("..type(value)..") "..value_text.."\n")
	end
	table.insert(result, "}")
	return table.concat(result,"")
end

-- local test = {
-- 	a = { x = 5, y = 7, z = -6 },
-- 	http = {
-- 		port = 80,
-- 		protocol = "http"
-- 	},
-- 	mode = "do_stuff",
-- 	apple = false,
-- 	deepa = { deepb = { deepc = { yay = "Happy Birthday!" } }}
-- }
-- print(inspect(test))

return inspect
