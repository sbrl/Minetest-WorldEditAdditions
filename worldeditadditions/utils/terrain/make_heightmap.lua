local wea = worldeditadditions
local Vector3 = wea.Vector3


--- Given a manip object and associates, generates a 2D x/z heightmap.
-- Note that pos1 and pos2 should have already been pushed through
-- worldedit.sort_pos(pos1, pos2) before passing them to this function.
-- @param	pos1	Vector		Position 1 of the region to operate on
-- @param	pos2	Vector		Position 2 of the region to operate on
-- @param	manip	VoxelManip	The VoxelManip object.
-- @param	area	area		The associated area object.
-- @param	data	table		The associated data object.
-- @return	table,table			The ZERO-indexed heightmap data (as 1 single flat array), followed by the size of the heightmap in the form { z = size_z, x = size_x }.
local function make_heightmap(pos1, pos2, manip, area, data)
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
				if not (wea.is_airlike(data[i]) or wea.is_liquidlike(data[i])) then
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
	
	local heightmap_size = Vector3.new(
		(pos2.x - pos1.x) + 1,	-- x
		0,						-- y
		(pos2.z - pos1.z) + 1	-- z
	)
	
	return heightmap, heightmap_size
end


return make_heightmap
