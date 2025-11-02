local weac = worldeditadditions_core
local Vector3 = weac.Vector3

-- ███████   █████   ██    ██  ███████ 
-- ██       ██   ██  ██    ██  ██      
-- ███████  ███████  ██    ██  █████   
--      ██  ██   ██   ██  ██   ██      
-- ███████  ██   ██    ████    ███████ 

function worldeditadditions.save(pos1, pos2, offset, filepath)
	-- pos1, pos2 = Vector3.sort(pos1, pos2) -- not sure sorting is needed here
	
	offset = offset or Vector3.new()
	
	local manip, _area = worldedit.manip_helpers.init(pos1, pos2)
	print("DEBUG:wea/save MANIP")
	
	local svr = weac.io.StagedVoxelRegion.NewFromVoxelManip(pos1, pos2, offset, manip)
	print("DEBUG:wea/save StagedVoxelRegion", svr)
	
	-- TODO implement better error messages in theres
	local success, err = svr:save(filepath)
	
	if not success then return success, err or "Error: Failed saving to disk." end
	
	return true, "Saved " .. Vector3.volume(pos1, pos2) .. " nodes to disk"
end