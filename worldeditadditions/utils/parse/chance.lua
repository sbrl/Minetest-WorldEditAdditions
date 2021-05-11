
--- Parses a chance value, and returns the 1-in-N value thereof.
-- @param	str	string	The string to parse.
-- @returns	number|nil	The 1-in-N chance if parsing was successful, otherwise nil.
function worldeditadditions.parse.chance(str)
	if tonumber(str) ~= nil then return tonumber(str) end
	if str:sub(#str) == "%" then
		local result = tonumber(str:sub(1, #str-1))
		if result == nil then return nil end
		return 1 / (result / 100) -- Convert percentage to 1-in-N chance
	end
	return nil
end
