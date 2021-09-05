-- ███    ██  ██████  ██ ███████ ███████  █████  ██████  ██████  ██   ██    ██ ██████  ██████
-- ████   ██ ██    ██ ██ ██      ██      ██   ██ ██   ██ ██   ██ ██    ██  ██       ██ ██   ██
-- ██ ██  ██ ██    ██ ██ ███████ █████   ███████ ██████  ██████  ██     ████    █████  ██   ██
-- ██  ██ ██ ██    ██ ██      ██ ██      ██   ██ ██      ██      ██      ██    ██      ██   ██
-- ██   ████  ██████  ██ ███████ ███████ ██   ██ ██      ██      ███████ ██    ███████ ██████

--- Similar to cubeapply, except that it takes 2 positions and randomly keeps changes based on a noise pattern.
-- Takes a backup copy of the defined region, runs the given function, and then
-- restores the bits that aren't above the nosie threshold.
-- @param	{Position}	pos1	The 1st position defining the region boundary
-- @param	{Position}	pos2	The 2nd positioon defining the region boundary 
-- @param	{Function}	func	The function to call that performs the action in question. It is expected that the given function will accept no arguments.
function worldeditadditions.noiseapply2d(pos1, pos2, threshold, scale, func)
	local time_taken_all = worldeditadditions.get_ms_time()
	pos1, pos2 = worldeditadditions.Vector3.sort(pos1, pos2)
	if not threshold then threshold = 0.5 end
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip_before, area_before = worldedit.manip_helpers.init(pos1, pos2)
	local data_before = manip_before:get_data()
	
	local time_taken_fn = worldeditadditions.get_ms_time()
	func()
	time_taken_fn = worldeditadditions.get_ms_time() - time_taken_fn
	
	local manip_after, area_after = worldedit.manip_helpers.init(pos1, pos2)
	local data_after = manip_after:get_data()
	
	local size2d = pos2 - pos1 + worldeditadditions.Vector3.new(1, 1, 1)
	print("DEBUG pos1", pos1, "pos2", pos2, "size2d", size2d)
	local success, noise = worldeditadditions.noise.make_2d(size2d, pos1, {
		algorithm = "perlinmt",
		scale = scale
	})
	if not success then return success, noise end
	
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local i_before = area_before:index(x, y, z)
				local i_after = area_after:index(x, y, z)
				
				local i_noise = (z-pos1.z)*size2d.x + (x-pos1.x)
				
				-- Roll everything where the noise function returns less than 0.5
				if noise[i_noise] < threshold then
					data_after[i_after] = data_before[i_before]
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
