local weac = worldeditadditions_core
local Vector3 = weac.Vector3

local function save(filepath, pos1, pos2)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	core.create_schematic(pos1, pos2, nil, filepath, nil)
	return true, "Written schematic to '"..tostring(filepath).."' successfully"
end

local function load(filename, pos1, pos2) -- → returns VoxelManipulator for region, DOES NOT MANIPULATE THE WORLD DIRECTLY, bc otherwise can't manip state properly
	pos1, pos2 = Vector3.sort(pos1, pos2)
	local schematic = core.read_schematic(filename, nil) -- TODO this may or may not load the thing
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	core.place_schematic_on_vmanip(manip, pos1, schematic, "0", nil, true, nil)
	return true, manip, area
	-- later, if you don't have the `area`, you can do local emerged_pos1, emerged_pos2 = manip:get_emerged_area(), then local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
end

return {
	save,
	load
}