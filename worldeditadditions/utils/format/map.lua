--- Formats a key-value table of values as a string.
-- @param	map		table	The table of key-value pairs to format.
-- @returns	string	The given table of key-value pairs formatted as a string.
function worldeditadditions.format.map(map)
	local result = {}
	for key, value in pairs(map) do
		table.insert(result, key.."\t"..tostring(value))
	end
	return table.concat(result, "\n")
end
