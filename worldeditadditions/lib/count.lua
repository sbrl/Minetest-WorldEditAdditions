--- Counts the nodes in a given area.
-- @module worldeditadditions.count

--  ██████  ██████  ██    ██ ███    ██ ████████
-- ██      ██    ██ ██    ██ ████   ██    ██
-- ██      ██    ██ ██    ██ ██ ██  ██    ██
-- ██      ██    ██ ██    ██ ██  ██ ██    ██
--  ██████  ██████   ██████  ██   ████    ██
function worldeditadditions.count(pos1, pos2)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	local counts = {}
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local next = data[area:index(x, y, z)]
				if not counts[next] then
					counts[next] = 0
				end
				counts[next] = counts[next] + 1
			end
		end
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
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	-- worldedit.manip_helpers.finish(manip, data)
	
	return true, results, total
end
