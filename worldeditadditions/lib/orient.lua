local weac = worldeditadditions_core
local Vector3 = weac.Vector3

---
-- @module worldeditadditions



--  ██████  ██████  ██ ███████ ███    ██ ████████
-- ██    ██ ██   ██ ██ ██      ████   ██    ██   
-- ██    ██ ██████  ██ █████   ██ ██  ██    ██   
-- ██    ██ ██   ██ ██ ██      ██  ██ ██    ██   
--  ██████  ██   ██ ██ ███████ ██   ████    ██   



--- Re-orients the nodes in the given region around a given origin point using a set of rotations.
-- TODO Learn quaternions and make this more effiient.
-- @param	pos1	Vector3		Position 1 of the region to orient nodes in.
-- @param	pos2	Vector3		Position 2 of the region to orient nodes in.
-- @param	rotlist		table<{axis: string, rad: number}>	The list of rotations. Rotations will be processed in order. Each rotation is a table with a SINGLE axis as a string (x, y, z, -x, -y, or -z; the axis parameter), and an amount in radians to rotate by (the rad parameter).
-- @returns	bool,string|table<{changed: number}>	A success boolean (true == success; false == failure), followed by either an error message as a string if success == false or a table of statistics if success == true.
--
-- Currently the only parameter in the statistics table is changed, which is a number representing the number of nodes that were rotated.
--
-- This is NOT NECESSARILY the number of nodes in the target region..... since rotations and roundings mean the target area the source region was rotated into could have slightly more or less nodes than the source region.
function worldeditadditions.orient(pos1, pos2, rotlist)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	--- 1: Compile the rotation list
	local rotlist_c = weac.rotation.rotlist_compile(rotlist)
	
	--- 2: Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local stats = {
		count = 0
	}
	
	local param2_cache = {}
	
	for i in area:iterp(pos1, pos2) do
		-- data[i]
		
		stats.count = stats.count + 1
	end
	
	--- 8: Return
	return true, stats
end
