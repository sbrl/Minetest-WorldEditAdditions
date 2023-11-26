local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3




-- ███    ██  ██████  ██████  ███████
-- ████   ██ ██    ██ ██   ██ ██     
-- ██ ██  ██ ██    ██ ██   ██ █████  
-- ██  ██ ██ ██    ██ ██   ██ ██     
-- ██   ████  ██████  ██████  ███████
-- 
--  █████  ██████  ██████  ██   ██    ██
-- ██   ██ ██   ██ ██   ██ ██    ██  ██
-- ███████ ██████  ██████  ██     ████
-- ██   ██ ██      ██      ██      ██
-- ██   ██ ██      ██      ███████ ██

--- Like ellipsoidapply and airapply, but much more flexible, allowing custom sets of nodes to filter changes on. Any changes that don't replace nodes that match the given nodelist will be discarded.
-- Takes a backup copy of the defined region, runs the given function, and then
-- restores the bits around the edge that aren't inside the largest ellipsoid that will fit inside the defined region.
-- @param	pos1		Vector3		The 1st position defining the region boundary
-- @param	pos2		Vector3		The 2nd positioon defining the region boundary
-- @param	nodelist	string[]	The nodelist to match changes against. Any changes that don't replace nodes on this list will be discarded. The following special node names are also accepted: liquid, air. Note that all node names MUST be normalised, otherwise they won't be recognised!
-- @param	func		function	The function to call that performs the action in question. It is expected that the given function will accept no arguments.
function worldeditadditions.nodeapply(pos1, pos2, nodelist, func)
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
	
	-- Cache node ids for speed. Even if minetest.get_content_id is efficient, an extra function call is still relatively expensive when called 10K+ times on a large region.
	local nodeids = {}
	for i,nodename in ipairs(nodelist) do
		if nodename == "liquidlike" or nodename == "airlike" then
			table.insert(nodeids, nodename)
		else
			table.insert(nodeids, minetest.get_content_id(nodename))
		end
	end
	
	local allowed_changes = 0
	local denied_changes = 0
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local i_before = area_before:index(x, y, z)
				local i_after = area_after:index(x, y, z)
				local old_is_airlike = wea_c.is_airlike(data_before[i_before])
				
				-- Filter on the list of node ids
				local allow_replacement = false
				for i,nodeid in ipairs(nodeids) do
					if nodeid == "airlike" then
						allow_replacement = wea_c.is_airlike(data_before[i_before])
					elseif nodeid == "liquidlike" then
						allow_replacement = wea_c.is_liquidlike(data_before[i_before])
					else
						allow_replacement = data_before[i_before] == nodeid
					end
					if allow_replacement then break end
				end
				
				-- Roll back any changes that aren't allowed 
				-- ...but ensure we only count changed nodes
				if not allow_replacement then
					if data_after[i_after] ~= data_before[i_before] then
						allowed_changes = allowed_changes + 1
					end
					-- Roll back 
					data_after[i_after] = data_before[i_before]
				elseif data_after[i_after] ~= data_before[i_before] then
					denied_changes = denied_changes + 1
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	worldedit.manip_helpers.finish(manip_after, data_after)
	
	
	time_taken_all = wea_c.get_ms_time() - time_taken_all
	return true, {
		all = time_taken_all,
		fn = time_taken_fn,
		allowed_changes = allowed_changes,
		denied_changes = denied_changes
	}
end
