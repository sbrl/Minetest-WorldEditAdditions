local wea = worldeditadditions

local __smooth = dofile(wea.modpath.."/lib/sculpt/brushes/__smooth.lua")

return function(size)
	local success, brush, size_actual = __smooth(size, 1.25)
	return success, brush, size_actual
end
