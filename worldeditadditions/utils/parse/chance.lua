
--- Parses a chance value, and returns the 1-in-N value thereof.
-- @param	str				string	The string to parse.
-- @param	invert_percent	string	The operation mode. Valid modes: "1-in-n" (default), "weight". "1-in-n" refers to a 1-in-N chance of something happening (lower numbers mean greater likelihood). "weight", on the other hand, is instead a weighting that something will happen (higher numbers mean a greater likelihood).
-- @returns	number|nil	The 1-in-N chance if parsing was successful, otherwise nil.
function worldeditadditions.parse.chance(str, mode)
	if not mode then mode = "1-in-n" end
	if tonumber(str) ~= nil then return tonumber(str) end
	if str:sub(#str) == "%" then
		local result = tonumber(str:sub(1, #str-1))
		if not result then return nil end
		if mode == "weight" then result = 100 - result end
		return 1 / (result / 100) -- Convert percentage to 1-in-N chance
	end
	return nil
end
