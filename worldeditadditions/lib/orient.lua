local core = worldeditadditions_core
local Vector3 = core.Vector3

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
-- This is NOT NECESSARILY the number of nodes in the target region..... since not every node in the target region will support reorientation.
function worldeditadditions.orient(pos1, pos2, rotlist)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	--- 1: Compile the rotation list
	local rotlist_c = core.rotation.rotlist_compile(rotlist)
	
	--- 2: Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	local data_param2 = manip:get_param2_data()
	
	local stats = {
		count = 0
	}
	
	local cache_nodeid_2_param2_type = {}
	local cache_orient = {}
	
	local param2_cache = {}
	
	for i in area:iterp(pos1, pos2) do
		-- nodeid = data[i]
		local param2_type = "none"
		if cache_nodeid_2_param2_type[data[i]] == nil then
			local nodeid = minetest.get_name_from_content_id(data[i])
			local ndef = minetest.registered_nodes[nodeid]
			if type(ndef.paramtype2) ~= nil then
				param2_type = ndef.paramtype2
			end
			cache_nodeid_2_param2_type[data[i]] = param2_type
		else
			param2_type = cache_nodeid_2_param2_type[data[i]]
		end
		
		if param2_type ~= "none" then	
			local key = param2_type.."|"..data_param2[i]
			if cache_orient[key] == nil then
				cache_orient[key] = core.param2.orient(
					data_param2[i],
					param2_type,
					rotlist_c
				)
			end
			
			data_param2[i] = cache_orient[key]
			
			stats.count = stats.count + 1
		end
	end
	
	manip:set_param2_data(data_param2)
	manip:write_to_map(false)
	manip:update_map()
	
	--- 8: Return
	return true, stats
end
