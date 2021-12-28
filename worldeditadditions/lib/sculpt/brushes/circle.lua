local wea = worldeditadditions
local Vector3 = wea.Vector3


return function(size)
	local brush = {}
	
	local centre = (size / 2):floor()
	local minsize = math.floor(math.min(size.x, size.y) / 2)
	
	for y = size.y - 1, 0, -1 do
		for x = size.x - 1, 0, -1 do
			local i = y*size.x + x
			
			if math.floor((centre - Vector3.new(x, y, 0)):length()) < minsize then
				brush[i] = 1
			else
				brush[i] = 0
			end
		end
	end
	
	return true, brush, size
end
