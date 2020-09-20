-- ███████ ██      ██      ██ ██████  ███████ ███████  █████  ██████  ██████  ██   ██    ██
-- ██      ██      ██      ██ ██   ██ ██      ██      ██   ██ ██   ██ ██   ██ ██    ██  ██
-- █████   ██      ██      ██ ██████  ███████ █████   ███████ ██████  ██████  ██     ████
-- ██      ██      ██      ██ ██           ██ ██      ██   ██ ██      ██      ██      ██
-- ███████ ███████ ███████ ██ ██      ███████ ███████ ██   ██ ██      ██      ███████ ██

--- Similar to cubeapply, except that it takes 2 positions and only keeps an ellipsoid-shaped area defined by the boundaries of the defined region.
-- Takes a backup copy of the defined region, runs the given function, and then
-- restores the bits around the edge that aren't inside the largest ellipsoid that will fit inside the defined region.
-- @param	{Position}	pos1	The 1st position defining the region boundary
-- @param	{Position}	pos2	The 2nd positioon defining the region boundary 
-- @param	{Function}	func	The function to call that performs the action in question. It is expected that the given function will accept no arguments.
function worldeditadditions.ellipseapply(pos1, pos2, func)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip_before, area_before = worldedit.manip_helpers.init(pos1, pos2)
	local data_before = manip:get_data()
	
	func()
	
	local manip_after, area_after = worldedit.manip_helpers.init(pos1, pos2)
	local data_after = manip:get_data()
	
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
				local comp_x = (x - e_centre.x) / radius.x
				local comp_y = (y - e_centre.y) / radius.y
				local comp_z = (z - e_centre.z) / radius.z
				
				-- TODO finish this
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	worldedit.manip_helpers.finish(manip_after, data_after)
	
end
