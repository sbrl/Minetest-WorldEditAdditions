local wea = worldeditadditions
local Vector3 = wea.Vector3


return function(size)
	local brush = {}
	
	local centre = (size / 2):floor()
	local minsize = math.floor(math.min(size.x, size.y) / 2)
	
	local border = 1
	local kernel_size = 3
	
	-- Make the circle
	-- We don't use 0 to 1 here, because we have to blur it and the existing convolutional
	-- system rounds values.
	for y = size.y - 1, 0, -1 do
		for x = size.x - 1, 0, -1 do
			local i = y*size.x + x
			
			if math.floor((centre - Vector3.new(x, y, 0)):length()) < minsize - border then
				brush[i] = 100000
			else
				brush[i] = 0
			end
		end
	end
	
	-- Make the kernel & blur it
	local success, kernel = wea.conv.kernel_gaussian(kernel_size, 2)
	if not success then return success, kernel end
	
	local success2, msg = worldeditadditions.conv.convolve(
		brush, Vector3.new(size.x, 0, size.y),
		kernel, Vector3.new(kernel_size, 0, kernel_size)
	)
	if not success2 then return success2, msg end
	
	-- Rescale to be between 0 and 1
	local max_value = wea.max(brush)
	for i,value in pairs(brush) do
		brush[i] = brush[i] / max_value
	end
	
	return true, brush, size
end
