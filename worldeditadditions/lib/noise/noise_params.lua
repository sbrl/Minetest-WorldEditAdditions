--- Makes sure that the default settings are all present in the given params table.
-- This way not all params have to be specified by the user.
-- @param	params	table	The params table generated from the user's input.
-- @return	table	A NEW table with all the missing properties filled in with the default values.
function worldeditadditions.noise.params_apply_default(params)
	local params_default = {
		algorithm = "perlin",
		-- Zooms in and out
		scale = vector.new(1, 1, 1),
		-- Offset the generated noise by this vector.
		offset = vector.new(0, 0, 0),
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
		local default_copy = worldeditadditions.shallowcopy(params_default)
		worldeditadditions.table_apply(
			params_el,
			default_copy
		)
		params[i] = default_copy
	end
	
	return params
end
