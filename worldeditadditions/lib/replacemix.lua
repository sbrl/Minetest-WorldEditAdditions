local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

---
-- @module worldeditadditions


-- ██████  ███████ ██████  ██       █████   ██████ ███████ ███    ███ ██ ██   ██
-- ██   ██ ██      ██   ██ ██      ██   ██ ██      ██      ████  ████ ██  ██ ██
-- ██████  █████   ██████  ██      ███████ ██      █████   ██ ████ ██ ██   ███
-- ██   ██ ██      ██      ██      ██   ██ ██      ██      ██  ██  ██ ██  ██ ██
-- ██   ██ ███████ ██      ███████ ██   ██  ██████ ███████ ██      ██ ██ ██   ██

--- Like //mix, but replaces a given node instead.
-- TODO: Implement //replacesplat, which picks seeder nodes with a percentage chance, and then some growth passes with e.g. cellular automata? We should probably be pushing towards a release though round about now
-- @param	pos1		Vector3		pos1 of the defined region to replace nodes in.
-- @param	pos2		Vector3		pos2 of the defined region to replace nodes in.
-- @param	target_node	string		The normalised name of the node to replace.
-- @param	target_node_chance	number	The chance that the target_node should be replaced. This is a 1-in-N chance, so far example a value of 4 would be a 1 in 4 chance of replacement = 25% chance.
-- @param	replacements		table<string,number>	A map of normalised node names to relative weights for the nodes to replace `target_node` with. Nodes with higher weights will be chosen to replace `target_node` more often.
-- @returns	bool,number,number,table<number,number>		1. Whether the operation was successful or not.
-- 2. The number of nodes actually placed.
-- 3. The number of nodes that *could* have been replaced if `target_node_chance` were set to 1.
-- 4. A map of node ids to the number of times that node was placed.
function worldeditadditions.replacemix(pos1, pos2, target_node, target_node_chance, replacements)
	pos1, pos2 = Vector3.sort(pos1, pos2)
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
	local node_ids_replace, node_ids_replace_count = wea_c.make_weighted(replacements)
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
