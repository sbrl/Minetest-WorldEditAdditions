local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

---
-- @module worldeditadditions

-- ███████ ██      ██      ██ ██████  ███████  ██████  ██ ██████
-- ██      ██      ██      ██ ██   ██ ██      ██    ██ ██ ██   ██
-- █████   ██      ██      ██ ██████  ███████ ██    ██ ██ ██   ██
-- ██      ██      ██      ██ ██           ██ ██    ██ ██ ██   ██
-- ███████ ███████ ███████ ██ ██      ███████  ██████  ██ ██████
-- 
--  █████  ██████  ██████  ██   ██    ██
-- ██   ██ ██   ██ ██   ██ ██    ██  ██
-- ███████ ██████  ██████  ██     ████
-- ██   ██ ██      ██      ██      ██
-- ██   ██ ██      ██      ███████ ██

--- Similar to cubeapply, except that it takes 2 positions and only keeps an ellipsoid-shaped area defined by the boundaries of the defined region.
-- Takes a backup copy of the defined region, runs the given function, and then
-- restores the bits around the edge that aren't inside the largest ellipsoid that will fit inside the defined region.
-- @param	pos1	Vector3		The 1st position defining the region boundary
-- @param	pos2	Vector3		The 2nd positioon defining the region boundary 
-- @param	func	function	The function to call that performs the action in question. It is expected that the given function will accept no arguments.
function worldeditadditions.ellipsoidapply(pos1, pos2, func)
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
	
	local radius = (pos2 - pos1) / 2
	local e_centre = pos2 - radius
	
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local comp = (Vector3.new(x, y, z) - e_centre) / radius
				local distance_mult = Vector3.dot(comp, comp)
				
				-- Roll everything that's outside the ellipse back
				if distance_mult > 1 then
					data_after[area_after:index(x, y, z)] = data_before[area_before:index(x, y, z)]
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
