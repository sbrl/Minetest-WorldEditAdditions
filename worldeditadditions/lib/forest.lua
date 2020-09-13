--- Overlap command. Places a specified node on top of each column.
-- @module worldeditadditions.layers


function worldeditadditions.forest(pos1, pos2, sapling_weights)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	-- This command requires the bonemeal mod to be installed
	-- We check here too because other mods might call this function directly and bypass the chat command system
	if not minetest.get_modpath("bonemeal") then
		return false, "Bonemeal mod not loaded"
	end
	
	worldeditadditions.overlay(pos1, pos2, sapling_weights)
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	local id_air = minetest.get_content_id("air")
	
	local group_cache = {}
	local stats = { attempts = {}, failures = 0 }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				if not group_cache[data[i]] then
					group_cache[data[i]] = worldeditadditions.is_sapling(data[i])
				end
				
				if group_cache[data[i]] then
					local did_grow = false
					for i=1,100 do
						bonemeal:on_use(
							{ x = x, y = y, z = z },
							4,
							nil
						)
						
						local new_id_at_pos = minetest.get_content_id(minetest.get_node({ z = z, y = y, x = x }).name)
						if not group_cache[new_id_at_pos] then
							group_cache[new_id_at_pos] = worldeditadditions.is_sapling(new_id_at_pos)
						end
						if not group_cache[new_id_at_pos] then
							did_grow = true
							table.insert(stats.attempts, i)
							break
						end
					end
					if not did_grow then
						-- We can't set it to air here because then when we save back we would overwrite all the newly grown trees
						stats.failures = stats.failures + 1
					end
				end
			end
		end
	end
	
	-- Re-fetch the Voxel Manipulator to accountn for the new trees
	manip, area = worldedit.manip_helpers.init(pos1, pos2)
	data = manip:get_data()
	
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				if not group_cache[data[i]] then
					group_cache[data[i]] = worldeditadditions.is_sapling(data[i])
				end
				
				if group_cache[data[i]] then
					data[i] = air
				end
			end
		end
	end
	
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	return true, stats
end
