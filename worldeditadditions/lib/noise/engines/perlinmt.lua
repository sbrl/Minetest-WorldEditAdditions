local wea = worldeditadditions


local PerlinMT = {}
PerlinMT.__index = PerlinMT


function PerlinMT.new(seed, params)
	if not seed then seed = 0 end
	local result = {
		-- Provided by Minetest
		engine = PerlinNoise({
			offset = 0,
			scale = 1,
			spread = {x = 50, y = 50, z = 50},
			seed = seed,
			octaves = 1,
		    persistence = 0.63,
		    lacunarity = 2.0,
			flags = "defaults,absvalue",
		})
	}
	setmetatable(result, PerlinMT)
	return result
end

function PerlinMT:noise( x, y, z )
	local value = self.engine:get_3d(wea.Vector3.new(x, y, z))
	return value
end

return PerlinMT
