
--- Given a manip object and associates, generates a 2D x/z heightmap.
-- Note that pos1 and pos2 should have already been pushed through
-- worldedit.sort_pos(pos1, pos2) before passing them to this function.
-- @param	pos1	Vector		Position 1 of the region to operate on
-- @param	pos2	Vector		Position 2 of the region to operate on
-- @param	manip	VoxelManip	The VoxelManip object.
-- @param	area	area		The associated area object.
-- @param	data	table		The associated data object.
-- @return	table,table			The ZERO-indexed heightmap data (as 1 single flat array), followed by the size of the heightmap in the form { z = size_z, x = size_x }.
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
				if not (worldeditadditions.is_airlike(data[i]) or worldeditadditions.is_liquidlike(data[i])) then
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
	
	local heightmap_size = {
		z = (pos2.z - pos1.z) + 1,
		x = (pos2.x - pos1.x) + 1
	}
	
	return heightmap, heightmap_size
end

--- Calculates a normal map for the given heightmap.
-- Caution: This method (like worldeditadditions.make_heightmap) works on
-- X AND Z, and NOT x and y. This means that the resulting 3d normal vectors
-- will have the z and y values swapped.
-- @param	heightmap		table	A ZERO indexed flat heightmap. See worldeditadditions.make_heightmap().
-- @param	heightmap_size	int[]	The size of the heightmap in the form [ z, x ]
-- @return	Vector[]		The calculated normal map, in the same form as the input heightmap. Each element of the array is a 3D Vector (i.e. { x, y, z }) representing a normal.
function worldeditadditions.calculate_normals(heightmap, heightmap_size)
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
			
			result[hi] = worldeditadditions.vector.normalize({
				x = left - right,
				y = 2, -- Z & Y are flipped
				z = down - up
			})
			
			-- print("[normals] at "..hi.." ("..x..", "..z..") normal "..worldeditadditions.vector.tostring(result[hi]))
		end
	end
	return result
end

--- Applies changes to a heightmap to a Voxel Manipulator data block.
-- @param	pos1	vector		Position 1 of the defined region
-- @param	pos2	vector		Position 2 of the defined region
-- @param	area	VoxelArea	The VoxelArea object (see worldedit.manip_helpers.init)
-- @param	data	number[]	The node ids data array containing the slice of the Minetest world extracted using the Voxel Manipulator.
-- @param	heightmap_old	number[]	The original heightmap from worldeditadditions.make_heightmap.
-- @param	heightmap_new	number[]	The new heightmap containing the altered updated values. It is expected that worldeditadditions.shallowcopy be used to make a COPY of the data worldeditadditions.make_heightmap for this purpose. Both heightmap_old AND heightmap_new are REQUIRED in order for this function to work.
-- @param	heightmap_size	vector	The x / z size of the heightmap. Any y value set in the vector is ignored.
-- 
function worldeditadditions.apply_heightmap_changes(pos1, pos2, area, data, heightmap_old, heightmap_new, heightmap_size)
	local stats = { added = 0, removed = 0 }
	local node_id_air = minetest.get_content_id("air")
	local node_id_ignore = minetest.get_content_id("ignore")
	
	for z = heightmap_size.z, 0, -1 do
		for x = heightmap_size.x, 0, -1 do
			local hi = z*heightmap_size.x + x
			
			local height_old = heightmap_old[hi]
			local height_new = heightmap_new[hi]
			-- print("[conv/save] hi", hi, "height_old", heightmap_old[hi], "height_new", heightmap_new[hi], "z", z, "x", x, "pos1.y", pos1.y)
			
			-- Lua doesn't have a continue statement :-/
			if height_old == height_new then
				-- noop
			elseif height_new < height_old then
				local node_id_replace = data[area:index(
					pos1.x + x,
					pos1.y + height_old + 1,
					pos1.z + z
				)]
				-- Unlikely, but if it can happen, it *will* happen.....
				if node_id_replace == node_id_ignore then
					node_id_replace = node_id_air
				end
				stats.removed = stats.removed + (height_old - height_new)
				local y = height_new
				while y < height_old do
					local ci = area:index(pos1.x + x, pos1.y + y, pos1.z + z)
					-- print("[conv/save] remove at y", y, "→", pos1.y + y, "current:", minetest.get_name_from_content_id(data[ci]))
					if data[ci] ~= node_id_ignore then
						data[ci] = node_id_replace
					end
					y = y + 1
				end
			else -- height_new > height_old
				-- We subtract one because the heightmap starts at 1 (i.e. 1 = 1 node in the column), but the selected region is inclusive
				local node_id = data[area:index(pos1.x + x, pos1.y + (height_old - 1), pos1.z + z)]
				-- print("[conv/save] filling with ", node_id, "→", minetest.get_name_from_content_id(node_id))
				
				stats.added = stats.added + (height_new - height_old)
				local y = height_old
				while y < height_new do
					local ci = area:index(pos1.x + x, pos1.y + y, pos1.z + z)
					-- print("[conv/save] add at y", y, "→", pos1.y + y, "current:", minetest.get_name_from_content_id(data[ci]))
					if data[ci] ~= node_id_ignore then
						data[ci] = node_id
					end
					y = y + 1
				end
			end
		end
	end
	
	return true, stats
end
