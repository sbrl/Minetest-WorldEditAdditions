
-- ███    ███  █████  ██   ██ ███████         ██████  ██████
-- ████  ████ ██   ██ ██  ██  ██                   ██ ██   ██
-- ██ ████ ██ ███████ █████   █████            █████  ██   ██
-- ██  ██  ██ ██   ██ ██  ██  ██              ██      ██   ██
-- ██      ██ ██   ██ ██   ██ ███████ ███████ ███████ ██████


-- Generate a flat array of 2D noise.
-- Written with help from https://www.redblobgames.com/maps/terrain-from-noise/
-- @param	size	Vector	An x/y vector representing the size of the noise area to generate.
-- @param	params	table|table<table>	A table of noise params to use to generate the noise. Values that aren't specified are filled in automatically. If a table of tables is specified, it is interpreted as multiple octaves of noise to apply in sequence.
function worldeditadditions.noise.make_2d(size, start_pos, params)
	local result = {}
	
	print("size x", size.x, "z", size.z, "start_pos x", start_pos.x, "z", start_pos.z)
	
	for i, layer in ipairs(params) do
		local generator
		if layer.algorithm == "perlin" then
			generator = worldeditadditions.noise.Perlin.new()
		else -- We don't have any other generators just yet
			return false, "Error: Unknown noise algorithm '"..tostring(layer.algorithm).."' in layer "..i.." of "..#params.." (available algorithms: perlin)."
		end
		
		for x = 0, size.x do
			for y = 0, size.z do
				local i = y*size.x + x
				
				local noise_x = (x + 100000+start_pos.x+layer.offset.x) * layer.scale.x
				local noise_y = (y + 100000+start_pos.z+layer.offset.z) * layer.scale.z
				local noise_value = generator:noise(noise_x, noise_y, 0)
				
				-- print("DEBUG NOISE x", noise_x, "y", noise_y, "value", noise_value)
				if type(result[i]) ~= "number" then result[i] = 0 end
				result[i] = result[i] + (noise_value ^ layer.exponent) * layer.multiply + layer.add
			end
		end
		
	end
	
	for x = 0, size.x do
		for y = 0, size.z do
			local i = y*size.x + x
			result[i] = worldeditadditions.round(result[i])
		end
	end
	
	print("NOISE\n", worldeditadditions.format.array_2d(result, size.x))
	
	return true, result
end
