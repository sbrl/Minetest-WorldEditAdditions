--- Counts the nodes in a given area.
-- @module worldeditadditions.count

--  ██████  ██████  ██    ██ ███    ██ ████████
-- ██      ██    ██ ██    ██ ████   ██    ██
-- ██      ██    ██ ██    ██ ██ ██  ██    ██
-- ██      ██    ██ ██    ██ ██  ██ ██    ██
--  ██████  ██████   ██████  ██   ████    ██
function worldeditadditions.count(pos1, pos2, do_human_counts)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	local counts = {}
	for i in area:iterp(pos1, pos2) do
		if not counts[data[i]] then
			counts[data[i]] = 0
		end
		counts[data[i]] = counts[data[i]] + 1
	end
	
	local total = worldedit.volume(pos1, pos2)
	
	local results = {}
	for node_name, count in pairs(counts) do
		table.insert(results, {
			count,
			tostring(worldeditadditions.round((count / total) * 100, 2)).."%",
			minetest.get_name_from_content_id(node_name)
		})
	end
	table.sort(results, function(a, b) return a[1] < b[1] end)
	
	if do_human_counts then
		for key,item in pairs(results) do
			item[1] = worldeditadditions.format.human_size(item[1], 2)
		end
	end
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	-- worldedit.manip_helpers.finish(manip, data)
	
	return true, results, total
end
