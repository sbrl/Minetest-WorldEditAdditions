
--- Given a manip object and associates, generates a 2D x/z heightmap.
-- Note that pos1 and pos2 should have already been pushed through
-- worldedit.sort_pos(pos1, pos2) before passing them to this function.
-- @param	pos1	Vector		Position 1 of the region to operate on
-- @param	pos2	Vector		Position 2 of the region to operate on
-- @param	manip	VoxelManip	The VoxelManip object.
-- @param	area	area		The associated area object.
-- @param	data	table		The associated data object.
-- @return	table	The ZERO-indexed heightmap data (as 1 single flat array).
function worldeditadditions.make_heightmap(pos1, pos2, manip, area, data)
	-- z y x (in reverse for little-endian machines) is the preferred loop order, but that isn't really possible here
	
	local heightmap = {}
	local hi = 0
	local changes = { updated = 0, skipped_columns = 0 }
	for z = pos1.z, pos2.z, 1 do
		for x = pos1.x, pos2.x, 1 do
			local found_node = false
			-- Scan each column top to bottom
			for y = pos2.y+1, pos1.y, -1 do
				local i = area:index(x, y, z)
				if not worldeditadditions.is_airlike(data[i]) then
					-- It's the first non-airlike node in this column
					-- Start heightmap values from 1 (i.e. there's at least 1 node in the column)
					heightmap[hi] = (y - pos1.y) + 1 
					found_node = true
					break
				end
			end
			
			if not found_node then heightmap[hi] = -1 end
			hi = hi + 1
		end
	end
	
	return heightmap
end

--- Calculates a normal map for the given heightmap.
-- Caution: This method (like worldeditadditions.make_heightmap) works on
-- X AND Z, and NOT x and y. This means that the resulting 3d normal vectors
-- will have the z and y values swapped.
-- @param	heightmap		table	A ZERO indexed flat heightmap. See worldeditadditions.make_heightmap().
-- @param	heightmap_size	int[]	The size of the heightmap in the form [ z, x ]
-- @return	Vector[]		The calculated normal map, in the same form as the input heightmap. Each element of the array is a 3D Vector (i.e. { x, y, z }) representing a normal.
function worldeditadditions.calculate_normals(heightmap, heightmap_size)
	local result = {}
	for z = heightmap_size[0], 0, -1 do
		for x = heightmap_size[1], 0, -1 do
			-- Algorithm ref https://stackoverflow.com/a/13983431/1460422
			-- Also ref Vector.mjs, which I implemented myself (available upon request)
			local hi = z*heightmap_size[1] + x
			-- Default to this pixel's height
			local up = heightmap[hi]
			local down = heightmap[hi]
			local left = heightmap[hi]
			local right = heightmap[hi]
			if z - 1 > 0 then up = heightmap[(z-1)*heightmap_size[1] + x] end
			if z + 1 < heightmap_size[1] then down = heightmap[(z+1)*heightmap_size[1] + x] end
			if x - 1 > 0 then left = heightmap[z*heightmap_size[1] + (x-1)] end
			if x + 1 < heightmap_size[0] then right = heightmap[z*heightmap_size[1] + (x+1)] end
			
			result[hi] = worldeditadditions.vector.normalize({
				x = left - right,
				y = 2, -- Z & Y are flipped
				z = down - up
			})
		end
	end
	return result
end
