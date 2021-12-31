-- ██       █████  ██    ██ ███████ ██████  ███████
-- ██      ██   ██  ██  ██  ██      ██   ██ ██
-- ██      ███████   ████   █████   ██████  ███████
-- ██      ██   ██    ██    ██      ██   ██      ██
-- ███████ ██   ██    ██    ███████ ██   ██ ███████

local wea = worldeditadditions

local function print_slopes(slopemap, width)
	local copy = wea.table.shallowcopy(slopemap)
	for key,value in pairs(copy) do
		copy[key] = wea.round(math.deg(value), 2)
	end
	
	worldeditadditions.format.array_2d(copy, width)
end

--- Replaces the non-air nodes in each column with a list of nodes from top to bottom.
-- @param	pos1			Vector		Position 1 of the region to operate on
-- @param	pos2			Vector		Position 2 of the region to operate on
-- @param	node_weights	string[]	
-- @param	min_slope		number?		
-- @param	max_slope		number?		
function worldeditadditions.layers(pos1, pos2, node_weights, min_slope, max_slope)
	pos1, pos2 = wea.Vector3.sort(pos1, pos2)
	if not min_slope then min_slope = math.rad(0) end
	if not max_slope then max_slope = math.rad(180) end
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_ignore = minetest.get_content_id("ignore")
	
	local node_ids, node_ids_count = wea.unwind_node_list(node_weights)
	
	local heightmap, heightmap_size = wea.terrain.make_heightmap(
		pos1, pos2,
		manip, area, data
	)
	local slopemap = wea.terrain.calculate_slopes(heightmap, heightmap_size)
	-- worldeditadditions.format.array_2d(heightmap, heightmap_size.x)
	-- print_slopes(slopemap, heightmap_size.x)
	--luacheck:ignore 311
	heightmap = nil -- Just in case Lua wants to garbage collect it
	
	
	-- minetest.log("action", "pos1: " .. wea.vector.tostring(pos1))
	-- minetest.log("action", "pos2: " .. wea.vector.tostring(pos2))
	-- for i,v in ipairs(node_ids) do
	-- 	print("[layer] i", i, "node id", v)
	-- end
	-- z y x is the preferred loop order, but that isn't really possible here
	
	local changes = { replaced = 0, skipped_columns = 0, skipped_columns_slope = 0 }
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			local next_index = 1 -- We use table.insert() in make_weighted
			local placed_node = false
			
			local hi = (z-pos1.z)*heightmap_size.x + (x-pos1.x)
			
			-- print("DEBUG hi", hi, "x", x, "z", z, "slope", slopemap[hi], "as deg", math.deg(slopemap[hi]))
			
			-- Again, Lua 5.1 doesn't have a continue statement :-/
			if slopemap[hi] >= min_slope and slopemap[hi] <= max_slope then
				for y = pos2.y, pos1.y, -1 do
					local i = area:index(x, y, z)
					
					local is_air = wea.is_airlike(data[i])
					local is_ignore = data[i] == node_id_ignore
					
					if not is_air and not is_ignore then
						-- It's not an airlike node or something else odd
						data[i] = node_ids[next_index]
						next_index = next_index + 1
						changes.replaced = changes.replaced + 1
						
						-- If we're done replacing nodes in this column, move to the next one
						if next_index > #node_ids then
							break
						end
					end
				end
			else
				changes.skipped_columns_slope = changes.skipped_columns_slope + 1
			end
			
			if not placed_node then
				changes.skipped_columns = changes.skipped_columns + 1
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return changes
end
