--- Applies a layer of 2D noise over the terrain in the defined region.
-- @module worldeditadditions.noise2d

-- ███    ██  ██████  ██ ███████ ███████ ██████  ██████
-- ████   ██ ██    ██ ██ ██      ██           ██ ██   ██
-- ██ ██  ██ ██    ██ ██ ███████ █████    █████  ██   ██
-- ██  ██ ██ ██    ██ ██      ██ ██      ██      ██   ██
-- ██   ████  ██████  ██ ███████ ███████ ███████ ██████
--- Applies a layer of 2d noise over the terrain in the defined region.
-- @param	pos1			Vector	pos1 of the defined region
-- @param	pos2			Vector	pos2 of the defined region
-- @param	noise_params	table	A noise parameters table. Will be passed unmodified to PerlinNoise() from the Minetest API.
function worldeditadditions.noise2d(pos1, pos2, noise_params)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local heightmap_old, heightmap_size = worldeditadditions.make_heightmap(
		pos1, pos2,
		manip, area,
		data
	)
	local heightmap_new = worldeditadditions.shallowcopy(heightmap_old)
	
	local perlin_map = PerlinNoiseMap(noise_params, heightmap_size)
	
	-- TODO: apply the perlin noise map here
	
	local stats = { added = 0, removed = 0 }
	
	-- Save the modified nodes back to disk & return
	-- No need to save - this function doesn't actually change anything
	worldedit.manip_helpers.finish(manip, data)
	
	return true, stats
end
