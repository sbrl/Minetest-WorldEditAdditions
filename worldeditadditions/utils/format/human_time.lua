
--- Converts a float milliseconds into a human-readable string.
-- Ported from PHP human_time from Pepperminty Wiki: https://github.com/sbrl/Pepperminty-Wiki/blob/fa81f0d/core/05-functions.php#L82-L104
-- @param	ms		float	The number of milliseconds to convert.
-- @return	string	A human-readable string representing the input ms.
function worldeditadditions.format.human_time(ms)
	if type(ms) ~= "number" then return "unknown" end
	local tokens = {
		{ 31536000 * 1000, 'year' },
		{ 2592000 * 1000, 'month' },
		{ 604800 * 1000, 'week' },
		{ 86400 * 1000, 'day' },
		{ 3600 * 1000, 'hr' },
		{ 60 * 1000, 'min' },
		{ 1 * 1000, 's' },
		{ 1, 'ms'}
	}
	
	for _,pair in pairs(tokens) do
		if ms > pair[1] or pair[2] == "ms" then
			local unit = pair[2]
			if ms > 60 * 1000 and math.floor(ms / pair[1]) > 1 then
				unit = unit.."s"
			end
			return string.format("%.2f", ms / pair[1])..unit
		end
	end
end
