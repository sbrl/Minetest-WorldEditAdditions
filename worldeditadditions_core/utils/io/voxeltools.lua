local weac = worldeditadditions_core
local Vector3 = weac.Vector3

--- Converts data in a VoxelManip to a raw data array for serialisation.
-- TODO: Figure out the specifics of how this fits into StagedVoxelRegion, and whether or not StagedVoxelRegion has too many overrides or not. Then implement the counterpart raw2voxelmanip & integrate into WEA + StagedVoxelRegion
-- @param	voxelmanip	VoxelManipulator	The voxelmanip instance to extract data from.
-- @param	pos1		Vector3				Position 1 that defines the region to extract data from.
-- @param	pos2		Vector3				Position 2 that defines the region to extract data from.
local function voxelmanip2raw(voxelmanip, pos1, pos2)
	
	local pos1_sort, pos2_sort = Vector3.sort(pos1, pos2)
	local size = pos2_sort - pos1_sort
	
	local data = voxelmanip:get_data()
	local param2 = voxelmanip:get_param2_data()
	
	local pos1_manip, pos2_manip = voxelmanip:get_emerged_area()
	local area = VoxelArea:new({
		MinEdge = pos1_manip,
		MaxEdge = pos2_manip
	})
	pos1_manip = Vector3.clone(pos1_manip)
	pos2_manip = Vector3.clone(pos2_manip)
	
	local pos1_manip_sort, pos2_manip_sort = Vector3.sort(pos1_manip, pos2_manip)
	
	local result_data = {}
	local result_param2 = {}
	for z = pos2_sort.z, pos1_sort.z, -1 do
		for x = pos2_sort.x, pos1_sort.x, -1 do
			for y = pos2_sort.y, pos1_sort.y, -1 do
				local here = Vector3.new(x, y, z)
				local here_target = here - pos1_manip_sort
				local here_target_i = here_target.z * size.y * size.x + here_target.y * size.x + here_target.x -- Minetest flat arrays start from 1 (I thought they started from 0?!?!?!), but WEA flat arrays start from 0. Hence, we don't +1 here, though at some point we'll hafta update eeeevvvveerrrryyything...... :-(
				
				local here_source_i = area:index(x, y, z)
				result_data[here_target_i] = data[here_source_i]
				result_param2[here_target_i] = param2[here_source_i]
			end
		end
	end
	
	return result_data, result_param2
end

--- Makes a node id map for saving to disk based on a given RAW data array of node ids.
-- Also sequentially packs node ids to save space and potentially improve compression ratio, though this is unproven.
-- @param	data	table	The RAW data table to read ids from to build the map.
-- @returns table,table	A pair of maps to transform node ids from the world to the schematic file.
-- 
-- 1. The sID: number → node_name: string map to be saved in the schematic. sID stands for *schematic* id, which is NOT the same as the node id in the world.
-- 2. The wID → sID node id map. wID = the node id in the current Minetest world, and sID = the *schematic* id as in #1. All world node ids MUST be pushed through this map before being saved to the schematic file.
local function make_id_maps(data)
	local map = {}
	local id2id = {}
	local next_id = 0
	for _, wid in pairs(data) do
		if id2id[wid] == nil then
			id2id[wid] = next_id
			next_id = next_id + 1
			local sid = id2id[wid]
			map[sid] = minetest.get_name_from_content_id(wid)
		end
	end
	return map, id2id
end

--- Encodes a table of numbers (ZERO INDEXED) with run-length encoding.
-- The reason for the existence of this function is avoiding very long strings when serialising / deserialising. Long strings can be a problem in more ways than one.
-- @param	tbl		number[]	The table of numbers to runlength encode.
local function runlength_encode(tbl)
	local result = {}
	local next = 0
	local prev, count = nil, 0
	for i, val in pairs(tbl) do
		if prev ~= val then
			local msg = tostring(prev)
			if count > 1 then msg = tostring(count).."x"..msg end
			result[next] = msg
			next = next + 1
			count = 0
		end
		prev = val
		count = count + 1
	end
	local msg_last = tostring(prev)
	if count > 1 then msg_last = tostring(count) .. "x" .. msg_last end
	result[next] = msg_last
	
	return result
end


local function runlength_decode(tbl)
	local unpacked = {}
	local next = 0
	
	for i, val in pairs(tbl) do
		local count, sid = string.match(val, "(%d+)x(%d+)")
		if count == nil then
			unpacked[next] = tonumber(val)
			next = next + 1
		else
			sid = tonumber(sid)
			for _ = 1, count do
				unpacked[next] = sid
				next = next + 1
			end
		end
	end
	
	return unpacked
end

return {
	voxelmanip2raw,
	make_id_maps,
	
	runlength_encode,
	runlength_decode
}