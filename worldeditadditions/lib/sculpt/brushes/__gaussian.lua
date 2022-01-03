local wea = worldeditadditions
local Vector3 = wea.Vector3

--- Returns a smooth gaussian brush.
-- @param	size	Vector3		The target size of the brush. Note that the actual size of the brush will be different, as the gaussian function has some limitations.
-- @param	sigma=2	number		The 'smoothness' of the brush. Higher values are more smooth.
return function(size, sigma)
	local size = math.min(size.x, size.y)
	if size % 2 == 0 then size = size - 1 end
	if size < 1 then
		return false, "Error: Invalid brush size."
	end
	local success, gaussian = wea.conv.kernel_gaussian(size, sigma)
	
	-- Normalise values to fill the range 0 - 1
	-- By default, wea.conv.kernel_gaussian values add up to 1 in total
	local max = wea.max(gaussian)
	for i=0,size*size-1 do
		gaussian[i] = gaussian[i] / max
	end
	
	return success, gaussian, Vector3.new(size, size, 0)
end
