local wea = worldeditadditions

--- Parses a map of key-value pairs into a table.
-- For example, "count 25000 speed 0.8 rate_erosion 0.006 doawesome true" would be parsed into
-- the following table: { count = 25000, speed = 0.8, rate_erosion = 0.006, doawesome = true }.
-- @param	params_text	string		The string to parse.
-- @param	keywords	string[]?	Optional. A list of keywords. Keywords can be present on their own without a value. If found, their value will be automatically set to bool true.
-- @returns	table		A table of key-value pairs parsed out from the given string.
function worldeditadditions.parse.map(params_text, keywords)
	if not keywords then keywords = {} end
	local result = {}
	local parts = wea.split(params_text, "%s+", false)
	
	local last_key = nil
	local mode = "KEY"
	for i, part in ipairs(parts) do
		if mode == "VALUE" then
			-- Try converting to a number to see if it works
			local part_converted = tonumber(part)
			if part_converted == nil then part_converted = part end
			-- Look for bools
			if part_converted == "true" then part_converted = true end
			if part_converted == "false" then part_converted = false end
			result[last_key] = part_converted
			mode = "KEY"
		else
			last_key = part
			-- Keyword support
			if wea.table.contains(keywords, last_key) then
				result[last_key] = true
			else
				mode = "VALUE"
			end
		end
	end
	return true, result
end
