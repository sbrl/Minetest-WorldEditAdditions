local weac = worldeditadditions_core
local Vector3 = weac.Vector3

--- Compiles a list of rotations into something we can iteratively pass to Vector3.rotate3d.
-- This function is called internally. You are unlikely to need to call this function unless you are implementing something like worldeditadditions.rotate() or similar.
--
-- TODO Learn Quaternions.
-- @internal
-- @param	rotlist		table<{axis: string|Vector3, rad: number}>	The list of rotations. Rotations will be processed in order. Each rotation is a table with a SINGLE axis as a string (x, y, z, -x, -y, or -z; the axis parameter) or a Vector3 (only a SINGLE AXIS set to anything other than 0, and ONLY with a value of 1 or -1), and an amount in radians to rotate by (the rad parameter.
-- @returns	Vector3[]	The list of the compiled rotations, in a form that Vector3.rotate3d understands.
local function rotlist_compile(rotlist)
	return weac.table.map(rotlist, function(rot)
		--- 1: Construct a Vector3 to represent which axis we want to rotate on
		local rotval = Vector3.new(0, 0, 0)
		-- Assume that if it's a table, it's a Vector3 instance
		if type(rot) == "table" then
			rotval = rot.axis:clone()
		else
			-- Otherwise, treat it as a string
			if rot.axis:find("x", 1, true) then
				rotval.x = 1
			elseif rot.axis:find("y", 1, true) then
				rotval.y = 1
			elseif rot.axis:find("z", 1, true) then
				rotval.z = 1
			end
			if rot.axis:sub(1, 1) == "-" then
				rotval = rotval * -1
			end
		end


		--- 2: Rotate & apply amount of rotation to apply in radians
		return rotval * rot.rad
	end)
end


--- Applies a given list of rotatiosn rotlist to rotate pos1 and pos2 around a given origin, and returns a pos1/pos2 pair of a region that bounds the rotated area.
-- The returned pos1/pos2 are guaranteed to be integer values that fully enclose the rotated region. This function is designed to be used to e.g. find the bounds of a region to pass to a VoxelManip to ensure we grab everything.
-- @param	pos1	Vector3		Position 1 to rotate.
-- @param	pos2	Vector3		Position 2 to rotate.
-- @param	origin	Vector3		The position to rotate pos1 and pos2 around. May be a decimal value.
-- @param	rotlist	table<{axis: string, rad: number}>	The list of rotations. Rotations will be processed in order. Each rotation is a table with a SINGLE axis as a string (x, y, z, -x, -y, or -z; the axis parameter), and an amount in radians to rotate by (the rad parameter). See worldeditadditions.rotate() for more information.
-- @returns	Vector3,Vector3	A pos1 & pos2 that fully enclose the rotated region as described above.
local function find_rotated_vm(pos1, pos2, origin, rotlist)
	local rotlist_c = rotlist_compile(rotlist)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	local corners = {
		Vector3.new(pos1.x, pos1.y, pos1.z),
		Vector3.new(pos2.x, pos1.y, pos1.z),
		Vector3.new(pos1.x, pos2.y, pos1.z),
		Vector3.new(pos1.x, pos1.y, pos2.z),
		
		Vector3.new(pos2.x, pos2.y, pos1.z),
		Vector3.new(pos1.x, pos2.y, pos2.z),
		Vector3.new(pos2.x, pos1.y, pos2.z),
		Vector3.new(pos2.x, pos2.y, pos2.z),
	}
	local corners_rot = weac.table.map(corners, function(vec)
		local result = vec:clone()
		for i, rot in ipairs(rotlist_c) do
			result = Vector3.rotate3d(origin, result, rot)
		end
		return result
	end)
	
	local pos1_dstvm = weac.table.reduce(corners_rot, function(acc, vec)
		return Vector3.min(acc, vec)
	end, corners_rot[1]:clone())
	local pos2_dstvm = weac.table.reduce(corners_rot, function(acc, vec)
		return Vector3.max(acc, vec)
	end, corners_rot[1]:clone())
	
	print("DEBUG:find_rotated_vm pos1_dstvm", pos1_dstvm, "pos2_dstvm", pos2_dstvm)
		
	return pos1_dstvm, pos2_dstvm
end



return {
	find_rotated_vm = find_rotated_vm,
	rotlist_compile = rotlist_compile
}