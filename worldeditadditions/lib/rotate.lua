local weac = worldeditadditions_core
local Vector3 = weac.Vector3

-- ██████   ██████  ████████  █████  ████████ ███████
-- ██   ██ ██    ██    ██    ██   ██    ██    ██     
-- ██████  ██    ██    ██    ███████    ██    █████  
-- ██   ██ ██    ██    ██    ██   ██    ██    ██     
-- ██   ██  ██████     ██    ██   ██    ██    ███████

--- Compiles a list of rotations into something we can iteratively pass to Vector3.rotate3d.
-- TODO Learn Quaternions.
-- @param	rotlist		table<{axis: string|Vector3, rad: number}>	The list of rotations. Rotations will be processed in order. Each rotation is a table with a SINGLE axis as a string (x, y, z, -x, -y, or -z; the axis parameter) or a Vector3 (only a SINGLE AXIS set to anything other than 0, and ONLY with a value of 1 or -1), and an amount in radians to rotate by (the rad parameter.
-- @returns	Vector3[]	The list of the compiled rotations, in a form that Vector3.rotate3d understands.
local function __compile_rotlist(rotlist)
	return weac.table.map(rotlist, function(rot)
		--- 1: Construct a Vector3 to represent which axis we want to rotate on
		local rotval = Vector3.new(0, 0, 0)
		-- Assume that if it's a table, it's a Vector3 instance
		if type(rot) == "table" then
			print("DEBUG:__compile_rotlist rot is talble, ROT", weac.inspect(rot))
			rotval = rot.axis:clone()
		else
			-- Otherwise, treat it as a string
			if rot.axis:find("x", 1, true) then rotval.x = 1
			elseif rot.axis:find("y", 1, true) then rotval.y = 1
			elseif rot.axis:find("z", 1, true) then rotval.z = 1 end
			if rot.axis:sub(1, 1) == "-" then
				rotval = rotval * -1
			end
		end
		
		
		--- 2: Rotate & apply amount of rotation to apply in radians
		return rotval * rot.rad
	end)
end


--- Rotates the given region around a given origin point using a set of rotations.
-- TODO Learn quaternions and make this more effiient.
-- @param	pos1	Vector3		Position 1 of the defined region to rotate.
-- @param	pos2	Vector3		Position 2 of the defined region to rotate.
-- @param	origin	Vector3		The coordinates of the origin point around which we should rotate the region defined by pos1..pos2.
-- @param	rotlist		table<{axis: string, rad: number}>	The list of rotations. Rotations will be processed in order. Each rotation is a table with a SINGLE axis as a string (x, y, z, -x, -y, or -z; the axis parameter), and an amount in radians to rotate by (the rad parameter).
-- @returns	bool,string|table<{changed: number}>	A success boolean (true == success; false == failure), followed by either an error message as a string if success == false or a table of statistics if success == true.
-- 
-- Currently the only parameter in the statistics table is changed, which is a number representing the number of nodes that were rotated.
-- 
-- This is NOT NECESSARILY the number of nodes in the target region..... since rotations and roundings mean the target area the source region was rotated into could have slightly more or less nodes than the source region.
function worldeditadditions.rotate(pos1, pos2, origin, rotlist)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	--- 1: Compile the rotation list
	local rotlist_c = __compile_rotlist(rotlist)
	
	
	--- 2: Find the target area we will be rotating into
	-- First, rotate the defined region to find the target region
	local pos1_rot, pos2_rot = pos1:clone(), pos2:clone()
	for i, rot in ipairs(rotlist_c) do
		print("DEBUG origin", weac.inspect(origin), "pos1_rot", weac.inspect(pos1_rot), "pos2_rot", weac.inspect(pos2_rot), "rot", weac.inspect(rot))
		pos1_rot = Vector3.rotate3d(origin, pos1_rot, rot)
		pos2_rot = Vector3.rotate3d(origin, pos2_rot, rot)
	end
	-- Then, align it to the world axis so we can grab a VoxelManipulator
	-- We add 1 node either side for safety just in case of rounding errors when actually rotating
	local pos1_dstvm, pos2_dstvm = Vector3.sort(pos1_rot, pos2_rot)
	pos1_dstvm = pos1_dstvm:floor() - Vector3.new(1, 1, 1)
	pos2_dstvm = pos2_dstvm:ceil() + Vector3.new(1, 1, 1)
	
	
	--- 3: Check out a VoxelManipulator for the source and target regions
	local manip_src, area_src = worldedit.manip_helpers.init(pos1, pos2)
	local data_src = manip_src:get_data()
	
	local manip_dest, area_dest = worldedit.manip_helpers.init(pos1_dstvm, pos2_dstvm)
	local data_dest = manip_dest:get_data()
	-- TODO: Also carry param2 along for the ride
	
	
	--- 4: Do the rotation operation
	local count_rotated = 0
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local cpos_src = Vector3.new(x, y, z)
				local cpos_dest = cpos_src:clone()
				
				-- TODO: This is very inefficient. If we could use quaternions here to stack up the rotations, it would be much more efficient.
				for i, rot in ipairs(rotlist_c) do
					cpos_dest = Vector3.rotate3d(origin, cpos_dest, rot)
				end
				
				cpos_dest = cpos_dest:round()
				
				local i_src = area_src:index(cpos_src.x, cpos_src.y, cpos_src.z)
				local i_dest = area_dest:index(cpos_dest.x, cpos_dest.y, cpos_dest.z)
				
				data_dest[i_dest] = data_src[i_src]
				count_rotated = count_rotated + 1
			end
		end
	end
	
	--- 5: Wipe the source area & save it back to disk
	local id_air = minetest.get_content_id("air")
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				data_src[area_src:index(x, y, z)] = id_air
			end
		end
	end
	worldedit.manip_helpers.finish(manip_src, data_src)
	manip_src, area_src, data_src = nil, nil, nil
	
	
	
	--- 6: Save the destination back to disk
	-- Note that this MUST be AFTER the source is saved to disk, since the rotated region needs to overwrite the WIPED source area to avoid leaving an unrotated copy behind
	worldedit.manip_helpers.finish(manip_dest, data_dest)
	
	
	--- 5: Return
	return true, {
		count_rotated = count_rotated
	}
end