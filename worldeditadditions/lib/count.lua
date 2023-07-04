local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

--  ██████  ██████  ██    ██ ███    ██ ████████
-- ██      ██    ██ ██    ██ ████   ██    ██
-- ██      ██    ██ ██    ██ ██ ██  ██    ██
-- ██      ██    ██ ██    ██ ██  ██ ██    ██
--  ██████  ██████   ██████  ██   ████    ██

--- Counts the nodes in a given area.
-- @param	pos1			Vector3		pos1 of the defined region to count nodes in.
-- @param	pos2			Vector3		pos2 of the defined region to count nodes in.
-- @param	do_human_counts	bool		Whether to return human-readable counts (as a string) instead of the raw numbers.
-- @returns	bool,table<number,number>,number	1. Whether the operation was successful or not.
-- 												2. A table mapping node ids to the number of that node id seen.
-- 												3. The total number of nodes counted.
function worldeditadditions.count(pos1, pos2, do_human_counts)
	pos1, pos2 = Vector3.sort(pos1, pos2)
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
			tostring(wea_c.round((count / total) * 100, 2)).."%",
			minetest.get_name_from_content_id(node_name)
		})
	end
	table.sort(results, function(a, b) return a[1] < b[1] end)
	
	if do_human_counts then
		for key,item in pairs(results) do
			item[1] = wea_c.format.human_size(item[1], 2)
		end
	end
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	-- worldedit.manip_helpers.finish(manip, data)
	
	return true, results, total
end
