
-- ███    ███  █████  ██   ██ ███████         ██████  ██████
-- ████  ████ ██   ██ ██  ██  ██                   ██ ██   ██
-- ██ ████ ██ ███████ █████   █████            █████  ██   ██
-- ██  ██  ██ ██   ██ ██  ██  ██              ██      ██   ██
-- ██      ██ ██   ██ ██   ██ ███████ ███████ ███████ ██████


-- Generate a flat array of 2D noise.
-- Written with help from https://www.redblobgames.com/maps/terrain-from-noise/
-- @param	size	Vector	An x/y vector representing the size of the noise area to generate.
-- @param	params	table|table<table>	A table of noise params to use to generate the noise. Values that aren't specified are filled in automatically. If a table of tables is specified, it is interpreted as multiple octaves of noise to apply in sequence.
function worldeditadditions.noise.make_2d(size, params)
	params = worldeditadditions.noise.params_apply_default(params)
	
	local result = {}
	
	local generator;
	if params.algorithm == "perlin" then
		generator = worldeditadditions.noise.perlin.new()
	else -- We don't have any other generators just yet
		return false, "Error: Unknown noise algorithm '"..params.."'."
	end
	
	for x=params.offset.x, params.offset.x+size.x do
		for y=params.offset.y, params.offset.y+size.y do
			local result = 0
			for i,params_octave in ipairs(params) do
				result = result + (generator:noise(x * scale.x, y * scale.y, 0) ^ params.exponent) * params.multiply + params.add
			end
			result[y*size.x + x] = result
		end
	end
	
	return result
end
