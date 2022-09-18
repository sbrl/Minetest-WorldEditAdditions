local wea = worldeditadditions
local Vector3 = wea.Vector3

--- Applies changes to a heightmap to a Voxel Manipulator data block.
-- @param	pos1	vector		Position 1 of the defined region
-- @param	pos2	vector		Position 2 of the defined region
-- @param	area	VoxelArea	The VoxelArea object (see worldedit.manip_helpers.init)
-- @param	data	number[]	The node ids data array containing the slice of the Minetest world extracted using the Voxel Manipulator.
-- @param	heightmap_old	number[]	The original heightmap from worldeditadditions.make_heightmap.
-- @param	heightmap_new	number[]	The new heightmap containing the altered updated values. It is expected that worldeditadditions.table.shallowcopy be used to make a COPY of the data worldeditadditions.make_heightmap for this purpose. Both heightmap_old AND heightmap_new are REQUIRED in order for this function to work.
-- @param	heightmap_size	vector	The x / z size of the heightmap. Any y value set in the vector is ignored.
-- @returns	bool, string|{ added: number, removed: number }	A bool indicating whether the operation was successful or not, followed by either an error message as a string (if it was not successful) or a table of statistics (if it was successful).
local function apply_heightmap_changes(pos1, pos2, area, data, heightmap_old, heightmap_new, heightmap_size)
	local stats = { added = 0, removed = 0 }
	local node_id_air = minetest.get_content_id("air")
	local node_id_ignore = minetest.get_content_id("ignore")
	
	for z = heightmap_size.z - 1, 0, -1 do
		for x = heightmap_size.x - 1, 0, -1 do
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

return apply_heightmap_changes
