local weac = worldeditadditions_core
local Vector3 = weac.Vector3

-- ███████   █████   ██    ██  ███████ 
-- ██       ██   ██  ██    ██  ██      
-- ███████  ███████  ██    ██  █████   
--      ██  ██   ██   ██  ██   ██      
-- ███████  ██   ██    ████    ███████ 

function worldeditadditions.save(pos1, pos2, offset, filepath)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	offset = offset or Vector3.new()
	
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	
	local svr = weac.io.StagedVoxelRegion.NewFromVoxelManip(pos1, pos2, offset, manip)
	
	-- TODO implement better error messages in theres
	local success = svr:save(filepath)
	
	if not success then return success, "Error: Failed saving to disk." end
end