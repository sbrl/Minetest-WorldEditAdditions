--- Serialises an arbitrary value to a string.
-- Note that although the resulting table *looks* like valid Lua, it isn't.
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
	
	local result = { "{\n" }
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
