
-- ███    ███  █████  ██   ██ ███████         ██████  ██████
-- ████  ████ ██   ██ ██  ██  ██                   ██ ██   ██
-- ██ ████ ██ ███████ █████   █████            █████  ██   ██
-- ██  ██  ██ ██   ██ ██  ██  ██              ██      ██   ██
-- ██      ██ ██   ██ ██   ██ ███████ ███████ ███████ ██████
local wea = worldeditadditions

-- Generate a flat array of 2D noise.
-- Written with help from https://www.redblobgames.com/maps/terrain-from-noise/
-- @param	size	Vector	An x/y vector representing the size of the noise area to generate.
-- @param	params	table|table<table>	A table of noise params to use to generate the noise. Values that aren't specified are filled in automatically. If a table of tables is specified, it is interpreted as multiple octaves of noise to apply in sequence.
function worldeditadditions.noise.make_2d(size, start_pos, params)
	params = worldeditadditions.noise.params_apply_default(params)
	
	local result = {}
	
	for layer_i, layer in ipairs(params) do
		local generator
		if layer.algorithm == "perlin" then
			generator = wea.noise.engines.Perlin.new()
		elseif layer.algorithm == "perlinmt" then
			generator = wea.noise.engines.PerlinMT.new()
		elseif layer.algorithm == "sin" then
			generator = wea.noise.engines.Sin.new()
		elseif layer.algorithm == "white" then
			generator = wea.noise.engines.White.new()
		elseif layer.algorithm == "red" then
			generator = wea.noise.engines.Red.new()
		elseif layer.algorithm == "infrared" then
			generator = wea.noise.engines.Infrared.new()
		else -- We don't have any other generators just yet
			return false, "Error: Unknown noise algorithm '"..tostring(layer.algorithm).."' in layer "..layer_i.." of "..#params.." (available algorithms: "..table.concat(wea.noise.engines.available, ", ")..")."
		end
		
		-- TODO: Optimise performance by making i count backwards in sequence
		for x = 0, size.x - 1 do
			for y = 0, size.z - 1 do
				local i = y*size.x + x
				
				local noise_x = (x + 100000+start_pos.x+layer.offset.x) * layer.scale.x
				local noise_y = (y + 100000+start_pos.z+layer.offset.z) * layer.scale.z
				local noise_value = generator:noise(noise_x, noise_y, 0)
				
				if type(result[i]) ~= "number" then result[i] = 0 end
				local result_before = result[i]
				result[i] = result[i] + (noise_value ^ layer.exponent) * layer.multiply + layer.add
				-- if layer_i == 1 and result[i] > 1 then
				-- 	print("NOISE TOO BIG noise_value", noise_value, "noise_x", noise_x, "noise_y", noise_y, "i", i, "result[i]: BEFORE", result_before, "AFTER", result[i])
				-- end
			end
		end
		
	end
	
	
	print("NOISE MAKE_2D\n")
	worldeditadditions.format.array_2d(result, size.x)
	
	
	-- We don't round here, because otherwise when we apply it it'll be inaccurate
	
	return true, result
end
