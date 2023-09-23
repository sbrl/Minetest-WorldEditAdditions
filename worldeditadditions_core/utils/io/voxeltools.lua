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
