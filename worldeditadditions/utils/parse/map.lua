
--- Parses a map of key-value pairs into a table.
-- For example, "count 25000 speed 0.8 rate_erosion 0.006 doawesome true" would be parsed into
-- the following table: { count = 25000, speed = 0.8, rate_erosion = 0.006, doawesome = true }.
-- @param	params_text	string	The string to parse.
-- @returns	table		A table of key-value pairs parsed out from the given string.
function worldeditadditions.parse.map(params_text)
	local result = {}
	local parts = worldeditadditions.split(params_text, "%s+", false)
	
	local last_key = nil
	for i, part in ipairs(parts) do
		if i % 2 == 0 then -- Lua starts at 1 :-/
			-- Try converting to a number to see if it works
			local part_converted = tonumber(part)
			if as_number == nil then part_converted = part end
			-- Look for bools
			if part_converted == "true" then part_converted = true end
			if part_converted == "false" then part_converted = false end
			result[last_key] = part
		else
			last_key = part
		end
	end
	return true, result
end
