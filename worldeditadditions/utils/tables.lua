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

--- SHALLOWLY applies the values in source to overwrite the equivalent keys in target.
-- Warning: This function mutates target!
-- @param	source	table	The source to take values from
-- @param	target	table	The target to write values to
function worldeditadditions.table_apply(source, target)
	print("[table_apply] start")
	for key, value in pairs(source) do
		print("[table_apply] Applying", key, "=", value)
		target[key] = value
	end
	print("[table_apply] end")
end
