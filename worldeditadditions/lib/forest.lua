local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

--- Places saplings and bonemeals them automatically to create a forest.
-- Note that the defined region is *the region that saplings are placed in*, so nodes may ultimately end up being replaced outside the defined region depending on the size of the tree that grows.
-- @param	pos1		Vector3		pos1 of the defined region to place saplings in.
-- @param	pos2		Vector3		pos2 of the defined region to place saplings in.
-- @param	density_multiplier	number	The density of the forest to create. Nominally 1. Higher values increase the density at which saplings are placed, thereby increasing the density of the resulting forest.
-- 
-- Note that sapling growth rules are respected, so there is a limit to the maximum density at which a forest can be generated.
-- @param	sapling_weights		table<string,number>	A table mapping (normalised) sapling names to their relative weight. Higher weights mean an increased chance of that particular sapling being chosen. Weights need not add up to any particular value. worldeditadditions.overlay() is used under the hood to place saplings.
-- @returns	bool,table<string,number>	1. Whether the operation was successful or not. For example, this command might fail if the `bonemeal` mod is not installed.
-- 										2. A table of statistics about the operation:
-- | Key			| Meaning	|
-- |----------------|-----------|
-- | `attempts`		| A table of numbers indicating how many bonemeal attempts each sapling took to grow. Saplings that failed to grow within 100 attempts are considered a failure and not logged in this table. |
-- | `attempts_avg`	| The average number of attempts saplings took to grow. |
-- | `failures`		| The number of saplings placed that failed to grow within the 100 attempts limit.	|
-- | `successes`	| The number of saplings that were placed and successfully grow into a tree. |
-- | `placed`		| A `table<number,number>` map of sapling node ids and how many of that sapling type successfully grew.
function worldeditadditions.forest(pos1, pos2, density_multiplier, sapling_weights)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	local weight_total = 0
	for _name,weight in pairs(sapling_weights) do
		weight_total = weight_total + weight
	end
	
	sapling_weights["air"] = math.ceil(weight_total * 100 * 1/density_multiplier)
	
	-- This command requires the bonemeal mod to be installed
	-- We check here too because other mods might call this function directly and bypass the chat command system
	if not minetest.get_modpath("bonemeal") then
		return false, "Bonemeal mod not loaded"
	end
	
	local overlay_stats = worldeditadditions.overlay(pos1, pos2, sapling_weights)
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	local id_air = minetest.get_content_id("air")
	
	local group_cache = {}
	local stats = { attempts = {}, failures = 0, placed = {} }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				local node_id = data[i]
				if not group_cache[node_id] then
					group_cache[node_id] = wea_c.is_sapling(node_id)
				end
				
				if group_cache[node_id] then
					local did_grow = false
					local new_id_at_pos
					local new_name_at_pos
					for attempt_number=1,100 do
						bonemeal:on_use(
							{ x = x, y = y, z = z },
							4,
							nil
						)
						
						new_name_at_pos = minetest.get_node({ z = z, y = y, x = x }).name
						new_id_at_pos = minetest.get_content_id(new_name_at_pos)
						if not group_cache[new_id_at_pos] then
							group_cache[new_id_at_pos] = wea_c.is_sapling(new_id_at_pos)
						end
						if not group_cache[new_id_at_pos] then
							did_grow = true
							-- Log the number of attempts it took to grow
							table.insert(stats.attempts, attempt_number)
							-- Update the running total of saplings that grew
							if not stats.placed[node_id] then
								stats.placed[node_id] = 0
							end
							stats.placed[node_id] = stats.placed[node_id] + 1
							-- print("incrementing id", node_id, "to", stats.placed[node_id])
							break
						end
					end
					if not did_grow then
						-- print("[//forest] Failed to grow sapling, detected node id", new_id_at_pos, "name", new_name_at_pos, "was originally", minetest.get_name_from_content_id(node_id))
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
					group_cache[data[i]] = wea_c.is_sapling(data[i])
				end
				
				if group_cache[data[i]] then
					data[i] = id_air
				end
			end
		end
	end
	
	stats.successes = #stats.attempts
	stats.attempts_avg = wea_c.average(stats.attempts)
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	return true, stats
end
