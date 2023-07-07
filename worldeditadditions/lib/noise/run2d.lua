local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███    ██  ██████  ██ ███████ ███████ ██████  ██████
-- ████   ██ ██    ██ ██ ██      ██           ██ ██   ██
-- ██ ██  ██ ██    ██ ██ ███████ █████    █████  ██   ██
-- ██  ██ ██ ██    ██ ██      ██ ██      ██      ██   ██
-- ██   ████  ██████  ██ ███████ ███████ ███████ ██████

--- Applies a layer of 2d noise over the terrain in the defined region.
-- @param	pos1			Vector	pos1 of the defined region
-- @param	pos2			Vector	pos2 of the defined region
-- @param	noise_params	table	A noise parameters table.
-- @returns	bool,table	1. Whether the operation was successful or not.
-- 2. A table of statistics from the operation. See `worldeditadditions.noise.apply_2d` for the format of this table.
function wea.noise.run2d(pos1, pos2, noise_params)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fill in the default params
	-- print("DEBUG noise_params_custom ", wea_c.format.map(noise_params))
	noise_params = wea.noise.params_apply_default(noise_params)
	-- print("DEBUG noise_params[1] ", wea_c.format.map(noise_params[1]))
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local heightmap_old, heightmap_size = wea_c.terrain.make_heightmap(
		pos1, pos2,
		manip, area,
		data
	)
	local heightmap_new = wea_c.table.shallowcopy(heightmap_old)
	
	local success, noisemap = wea.noise.make_2d(
		heightmap_size,
		pos1,
		noise_params)
	if not success then return success, noisemap end
	
	local message
	success, message = wea.noise.apply_2d(
		heightmap_new,
		noisemap,
		heightmap_size,
		pos1, pos2,
		noise_params[1].apply
	)
	if not success then return success, message end
	
	local stats
	success, stats = wea_c.terrain.apply_heightmap_changes(
		pos1, pos2,
		area, data,
		heightmap_old, heightmap_new,
		heightmap_size
	)
	if not success then return success, stats end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, stats
end
