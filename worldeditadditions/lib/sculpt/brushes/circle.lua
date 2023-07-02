local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

--- Makes a circle brush of a given size.
-- @name	circle
-- @param	size	Vector3		The desired sizez of the brush (only X and Y are considered; Z is ignored).
-- @returns	bool,brush,Vector3	Success bool, then the brush, then finally the actual size of the brush generated.
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
