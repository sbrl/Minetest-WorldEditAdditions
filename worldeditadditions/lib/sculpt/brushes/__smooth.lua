
--- Returns a smooth gaussian brush.
-- @param	size	Vector3		The target size of the brush. Note that the actual size fo the brush will be different, as the gaussian function has some limitations.
-- @param	sigma=2	number		The 'smoothness' of the brush. Higher values are more smooth.
return function(size, sigma)
	local size = math.min(size.x, size.y)
	if size % 2 == 0 then size = size - 1 end
	if size < 1 then
		return false, "Error: Invalid brush size."
	end
	local success, gaussian = worldeditadditions.conv.kernel_gaussian(size, sigma)
	return success, gaussian, { x = size, y = size }
end
