local wea = worldeditadditions

--- Makes sure that the default settings are all present in the given params table.
-- This way not all params have to be specified by the user.
-- @param	params	table	The params table generated from the user's input.
-- @return	table	A NEW table with all the missing properties filled in with the default values.
function worldeditadditions.noise.params_apply_default(params)
	local params_default = {
		-- How to apply the noise to the heightmap. Different values result in
		-- different effects:
		-- - The exact string "add": Noise values are added to each heightmap pixel.
		-- - The exact string "multiply": Each heightmap pixel is multiplied by the corresponding noise value.
		-- - A string in the form of digits followed by a percent sign (e.g. "40%"), then the noise will is remapped from the range 0 - 1 to the range -1 - +1, and then for each pixel in the heightmap will be altered at most the given percentage of the total height of the defined region.
		apply = "40%",
		-- The backend noise algorithm to use
		algorithm = "perlin",
		-- Zooms in and out
		scale = wea.Vector3.new(1, 1, 1),
		-- Offset the generated noise by this vector.
		offset = wea.Vector3.new(0, 0, 0),
		-- Apply this exponent to the resulting noise value
		exponent = 1,
		-- Multiply the resulting noise value by this number. Changes the "strength" of the noise
		multiply = 1,
		-- Add this number to the resulting noise value
		add = 0
		-- The seed to generate the noise with. nil = randomly chosen
		-- The perlin generator isn't currently seedable :-/
		-- seed = nil
	}
	
	if not params[1] then params = { params } end
	
	-- If params[1] is thing, this is a list of params
	-- This might be a thing if we're dealingw ith multiple octaves
	for i,params_el in ipairs(params) do
		local default_copy = worldeditadditions.table.shallowcopy(params_default)
		worldeditadditions.table.apply(
			params_el,
			default_copy
		)
		params[i] = default_copy
	end
	
	return params
end