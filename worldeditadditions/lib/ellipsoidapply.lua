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
-- @param	{Position}	pos1	The 1st position defining the region boundary
-- @param	{Position}	pos2	The 2nd positioon defining the region boundary 
-- @param	{Function}	func	The function to call that performs the action in question. It is expected that the given function will accept no arguments.
function worldeditadditions.ellipsoidapply(pos1, pos2, func)
	local time_taken_all = worldeditadditions.get_ms_time()
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip_before, area_before = worldedit.manip_helpers.init(pos1, pos2)
	local data_before = manip_before:get_data()
	
	local time_taken_fn = worldeditadditions.get_ms_time()
	func()
	time_taken_fn = worldeditadditions.get_ms_time() - time_taken_fn
	
	local manip_after, area_after = worldedit.manip_helpers.init(pos1, pos2)
	local data_after = manip_after:get_data()
	
	local radius = {
		x = (pos2.x - pos1.x) / 2,
		y = (pos2.y - pos1.y) / 2,
		z = (pos2.z - pos1.z) / 2
	}
	local e_centre = {
		x = pos2.x - radius.x,
		y = pos2.y - radius.y,
		z = pos2.z - radius.z
	}
	
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local x_comp = (x - e_centre.x) / radius.x
				local y_comp = (y - e_centre.y) / radius.y
				local z_comp = (z - e_centre.z) / radius.z
				
				local distance_mult = x_comp*x_comp + y_comp*y_comp + z_comp*z_comp
				
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
	
	
	time_taken_all = worldeditadditions.get_ms_time() - time_taken_all
	return true, { all = time_taken_all, fn = time_taken_fn }
end
