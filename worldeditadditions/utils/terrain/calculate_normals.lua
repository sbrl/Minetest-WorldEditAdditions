local wea = worldeditadditions
local Vector3 = wea.Vector3


--- Calculates a normal map for the given heightmap.
-- Caution: This method (like worldeditadditions.make_heightmap) works on
-- X AND Z, and NOT x and y. This means that the resulting 3d normal vectors
-- will have the z and y values swapped.
-- @param	heightmap		table	A ZERO indexed flat heightmap. See worldeditadditions.terrain.make_heightmap().
-- @param	heightmap_size	int[]	The size of the heightmap in the form [ z, x ]
-- @return	Vector[]		The calculated normal map, in the same form as the input heightmap. Each element of the array is a Vector3 instance representing a normal.
local function calculate_normals(heightmap, heightmap_size)
	-- print("heightmap_size: "..heightmap_size.x.."x"..heightmap_size.z)
	local result = {}
	for z = heightmap_size.z-1, 0, -1 do
		for x = heightmap_size.x-1, 0, -1 do
			-- Algorithm ref https://stackoverflow.com/a/13983431/1460422
			-- Also ref Vector.mjs, which I implemented myself (available upon request)
			local hi = z*heightmap_size.x + x
			-- Default to this pixel's height
			local up = heightmap[hi]
			local down = heightmap[hi]
			local left = heightmap[hi]
			local right = heightmap[hi]
			if z - 1 > 0 then up = heightmap[(z-1)*heightmap_size.x + x] end
			if z + 1 < heightmap_size.z-1 then down = heightmap[(z+1)*heightmap_size.x + x] end
			if x - 1 > 0 then left = heightmap[z*heightmap_size.x + (x-1)] end
			if x + 1 < heightmap_size.x-1 then right = heightmap[z*heightmap_size.x + (x+1)] end
			
			-- print("[normals] UP	| index", (z-1)*heightmap_size.x + x, "z", z, "z-1", z - 1, "up", up, "limit", 0)
			-- print("[normals] DOWN	| index", (z+1)*heightmap_size.x + x, "z", z, "z+1", z + 1, "down", down, "limit", heightmap_size.x-1)
			-- print("[normals] LEFT	| index", z*heightmap_size.x + (x-1), "x", x, "x-1", x - 1, "left", left, "limit", 0)
			-- print("[normals] RIGHT	| index", z*heightmap_size.x + (x+1), "x", x, "x+1", x + 1, "right", right, "limit", heightmap_size.x-1)
			
			result[hi] = Vector3.new(
				left - right,	-- x
				2,				-- y - Z & Y are flipped
				down - up		-- z
			):normalise()
			
			-- print("[normals] at "..hi.." ("..x..", "..z..") normal "..result[hi])
		end
	end
	return result
end

return calculate_normals
