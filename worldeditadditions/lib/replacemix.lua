--- Like //mix, but replaces a given node instead.
-- @module worldeditadditions.replacemix

-- ██████  ███████ ██████  ██       █████   ██████ ███████ ███    ███ ██ ██   ██
-- ██   ██ ██      ██   ██ ██      ██   ██ ██      ██      ████  ████ ██  ██ ██
-- ██████  █████   ██████  ██      ███████ ██      █████   ██ ████ ██ ██   ███
-- ██   ██ ██      ██      ██      ██   ██ ██      ██      ██  ██  ██ ██  ██ ██
-- ██   ██ ███████ ██      ███████ ██   ██  ██████ ███████ ██      ██ ██ ██   ██
function worldeditadditions.replacemix(pos1, pos2, target_node, target_node_chance, replacements)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_target = minetest.get_content_id(target_node)
	
	-- Initialise statistics
	local changed = 0
	local candidates = 0
	local distribution = {}
	
	-- Generate the list of node ids
	local node_ids_replace, node_ids_replace_count = worldeditadditions.make_weighted(replacements)
	for node_name, weight in pairs(replacements) do
		distribution[minetest.get_content_id(node_name)] = 0
	end
	
	for i in area:iterp(pos1, pos2) do
		
		if data[i] == node_id_target then
			candidates = candidates + 1
			if math.random(target_node_chance) == 1 then
				local next_id = node_ids_replace[math.random(node_ids_replace_count)]
				data[i] = next_id
				changed = changed + 1
				-- We initialised this above
				distribution[next_id] = distribution[next_id] + 1
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, changed, candidates, distribution
end
