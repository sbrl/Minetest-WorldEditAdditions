local core = worldeditadditions_core
local Vector3 = core.Vector3
---
-- @module worldeditadditions_core.param2

-- TODO Reimplement for facedir ref https://github.com/12Me21/screwdriver2/blob/master/init.lua#L75-L79

-- //set <nodename>
-- //set param2|p2 <param2>

-- In future, we'll support more param2_type values here.

local function param2_to_dir(param2_type, param2)
	if param2_type == "facedir" then
		return Vector3.clone(minetest.facedir_to_dir(param2))
	else
		return nil
	end
end

local function dir_to_param2(param2_type, dir)
	if param2_type == "facedir" then
		return minetest.dir_to_facedir(dir, true)
	else
		return nil
	end
end



--- Rotates the given param2 value of the given type by the given COMPILED list of rotations.
-- In other words, reorients a given param2 value of a given param2_type (aka paramtype2 in the Minetest engine but the Minetest engine naming scheme is dumb in this case) according to a given COMPILED rotation list. 
-- @param	param2		number		The param2 value to rotate.
-- @param	param2_type	string		The type of param2 value we're talking about here. Currently, only a value of `facedir` is supported.
-- @param	rotlist_c	Vector3[]	The list of vector rotations to apply to param2. Call `worldeditadditions_core.rotation.rotlist_compile` on a rotation list to get this value. Each one is iteratively applied using the `rotate` argument to Vector3.rotate3d.
-- @returns	number?		Returns the rotated param2 value, or nil if an invalid param2_type value was passed.
local function orient(param2, param2_type, rotlist_c)
	local dir = param2_to_dir(param2_type, param2)
	
	print("DEBUG:param2>orient dir", core.inspect(dir), "param2_type", param2_type)
	
	if dir == nil then return nil end
	local origin = Vector3.new(0, 0, 0)
	
	for _i, rot in ipairs(rotlist_c) do
		dir = Vector3.rotate3d(origin, dir, rot)
		print("DEBUG:param2>orient STEP AFTER dir", dir, "ROT", rot, "ORIGIN", origin)
	end
	
	dir = dir:round() -- Deal with floating-point rounding errors ref https://en.wikipedia.org/wiki/Round-off_error
	-- TODO may need to do this every iteration in the above for loop un the unlikely event we have issues here
	
	print("DEBUG:param2>orient FINAL dir", dir)
	
	return dir_to_param2(param2_type, dir)
end




return {
	orient = orient
}