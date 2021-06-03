--- Returns the key value pairs in a table as a single string
-- @param	tbl	table	input table
-- @param	sep	string	key value seperator
-- @param	new_line	string	key value pair delimiter
-- @return	string	concatenated table pairs
function worldeditadditions.table_tostring(tbl, sep, new_line)
    if type(sep) ~= "string" then sep = ": " end
    if type(new_line) ~= "string" then new_line = ", " end
    local ret = {}
    if type(tbl) ~= "table" then return "Error: input not table!" end
    for key,value in pairs(tbl) do
        ret:append(key)
        ret:append(sep)
        ret:append(value)
        ret:append(new_line)
    end
    return ret:concat("")
end
