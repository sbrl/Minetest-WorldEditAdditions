
--- Formats (usually large) numbers as human-readable strings.
-- Ported from PHP: https://github.com/sbrl/Pepperminty-Wiki/blob/0a81c940c5803856db250b29f54658476bc81e21/core/05-functions.php#L67
-- @param	n			number	The number to format.
-- @param	decimals	number	The number of decimal places to show.
-- @return	string		A formatted string that represents the given input number.
function worldeditadditions.format.human_size(n, decimals)
	local sizes = { "", "K", "M", "G", "T", "P", "E", "Y", "Z" }
	local factor = math.floor((#tostring(n) - 1) / 3)
	local multiplier = 10^(decimals or 0)
	local result = math.floor(0.5 + (n / math.pow(1000, factor)) * multiplier) / multiplier
	return result .. sizes[factor+1]
end
