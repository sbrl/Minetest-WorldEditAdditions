local wea = worldeditadditions
local Vector3 = wea.Vector3


--- Converts a 2d heightmap into slope values in radians.
-- Convert a radians to degrees by doing (radians*math.pi) / 180 for display,
-- but it is STRONGLY recommended to keep all internal calculations in radians.
-- @param	heightmap		table	A ZERO indexed flat heightmap. See worldeditadditions.terrain.make_heightmap().
-- @param	heightmap_size	int[]	The size of the heightmap in the form [ z, x ]
-- @return	Vector[]		The calculated slope map, in the same form as the input heightmap. Each element of the array is a (floating-point) number representing the slope in that cell in radians.
local function calculate_slopes(heightmap, heightmap_size)
	local normals = wea.terrain.calculate_normals(heightmap, heightmap_size)
	local slopes = {  }
	
	local up = wea.Vector3.new(0, 1, 0) -- Z & Y are flipped
	
	for z = heightmap_size.z-1, 0, -1 do
		for x = heightmap_size.x-1, 0, -1 do
			local hi = z*heightmap_size.x + x
			
			-- Ref https://stackoverflow.com/a/16669463/1460422
			-- slopes[hi] = wea.Vector3.dot_product(normals[hi], up)
			slopes[hi] = math.acos(normals[hi].y)
		end
	end
	
	return slopes
end

return calculate_slopes
