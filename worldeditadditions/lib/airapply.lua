local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

---
-- @module worldeditadditions

--  █████  ██ ██████
-- ██   ██ ██ ██   ██
-- ███████ ██ ██████
-- ██   ██ ██ ██   ██
-- ██   ██ ██ ██   ██
-- 
--  █████  ██████  ██████  ██   ██    ██
-- ██   ██ ██   ██ ██   ██ ██    ██  ██
-- ███████ ██████  ██████  ██     ████
-- ██   ██ ██      ██      ██      ██
-- ██   ██ ██      ██      ███████ ██

--- Like ellipsoidapply, but only keeps changes that replace airlike nodes, and discards any other changes made.
-- Takes a backup copy of the defined region, runs the given function, and then
-- restores the bits around the edge that aren't inside the largest ellipsoid that will fit inside the defined region.
-- @param	pos1	Position	The 1st position defining the region boundary
-- @param	pos2	Position	The 2nd positioon defining the region boundary 
-- @param	func	function	The function to call that performs the action in question. It is expected that the given function will accept no arguments.
function worldeditadditions.airapply(pos1, pos2, func)
	local time_taken_all = wea_c.get_ms_time()
	pos1, pos2 = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip_before, area_before = worldedit.manip_helpers.init(pos1, pos2)
	local data_before = manip_before:get_data()
	
	local time_taken_fn = wea_c.get_ms_time()
	func()
	time_taken_fn = wea_c.get_ms_time() - time_taken_fn
	
	local manip_after, area_after = worldedit.manip_helpers.init(pos1, pos2)
	local data_after = manip_after:get_data()
	
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local i_before = area_before:index(x, y, z)
				local i_after = area_after:index(x, y, z)
				local old_is_airlike = wea_c.is_airlike(data_before[i_before])
				
				-- Roll everything that replaces nodes that aren't airlike
				if not old_is_airlike then
					data_after[i_after] = data_before[i_before]
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	worldedit.manip_helpers.finish(manip_after, data_after)
	
	
	time_taken_all = wea_c.get_ms_time() - time_taken_all
	return true, { all = time_taken_all, fn = time_taken_fn }
end
