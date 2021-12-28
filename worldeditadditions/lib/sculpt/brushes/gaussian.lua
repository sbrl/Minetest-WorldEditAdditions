local wea = worldeditadditions

local __smooth = dofile(wea.modpath.."/lib/sculpt/brushes/__gaussian.lua")

return function(size)
	local success, brush, size_actual = __smooth(size, 3)
	return success, brush, size_actual
end
