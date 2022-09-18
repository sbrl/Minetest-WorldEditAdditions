
--- Shallow clones a table.
-- @source	http://lua-users.org/wiki/CopyTable
-- @param	orig	table	The table to clone.
-- @return	table	The cloned table.
local function shallowcopy(orig)
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

return shallowcopy
