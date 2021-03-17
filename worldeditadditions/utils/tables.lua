--- Shallow clones a table.
-- @source	http://lua-users.org/wiki/CopyTable
-- @param	orig	table	The table to clone.
-- @return	table	The cloned table.
function worldeditadditions.shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--- SHALLOW ONLY - applies the values in source to overwrite the equivalent keys in target.
-- Warning: This function mutates target!
-- @param	source	table	The source to take values from
-- @param	target	table	The target to write values to
function worldeditadditions.table_apply(source, target)
	for key, value in pairs(source) do
		target[key] = value
	end
end

--- Polyfill for unpack / table.unpack.
-- Calls unpack when available, and looks for table.unpack if unpack() isn't
-- found.
-- This is needed because in Lua 5.1 it's the global unpack(), but in Lua 5.4
-- it's moved to table.unpack().
function worldeditadditions.table_unpack(tbl, offset, count)
	if type(unpack) == "function" then
		return unpack(tbl, offset, count)
	else
		return table.unpack(tbl, offset, count)
	end
end

--- Returns only the last count items in a given numerical table-based list.
function worldeditadditions.table_get_last(tbl, count)
	return {worldeditadditions.table_unpack(
		tbl,
		math.max(0, (#tbl) - (count - 1))
	)}
end

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
