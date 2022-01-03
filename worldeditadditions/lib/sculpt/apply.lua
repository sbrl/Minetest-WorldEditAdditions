local wea = worldeditadditions
local Vector3 = wea.Vector3

--- Applies the given brush with the given height and size to the given position.
-- @param	pos1		Vector3		The position at which to apply the brush.
-- @param	brush_name	string		The name of the brush to apply.
-- @param	height		number		The height of the brush application.
-- @param	brush_size	Vector3		The size of the brush application. Values are interpreted on the X/Y coordinates, and NOT X/Z!
-- @returns	bool, string|{ added: number, removed: number }	A bool indicating whether the operation was successful or not, followed by either an error message as a string (if it was not successful) or a table of statistics (if it was successful).
local function apply(pos1, brush_name, height, brush_size)
	-- 1: Get & validate brush
	local success, brush, brush_size_actual = wea.sculpt.make_brush(brush_name, brush_size)
	if not success then return success, brush end
	
	-- print(wea.sculpt.make_preview(brush, brush_size_actual))
	
	local brush_size_terrain = Vector3.new(
		brush_size_actual.x,
		0,
		brush_size_actual.y
	)
	local brush_size_radius = (brush_size_terrain / 2):floor()
	
	-- To try and make sure we catch height variations
	local buffer = Vector3.new(0, math.min(height*2, 100), 0)
	
	local pos1_compute = pos1 - brush_size_radius - buffer
	local pos2_compute = pos1 + brush_size_radius + Vector3.new(0, height, 0) + buffer
	
	pos1_compute, pos2_compute = Vector3.sort(
		pos1_compute,
		pos2_compute
	)
	
	-- 2: Fetch the nodes in the specified area, extract heightmap
	local manip, area = worldedit.manip_helpers.init(pos1_compute, pos2_compute)
	local data = manip:get_data()
	
	local heightmap, heightmap_size = wea.terrain.make_heightmap(
		pos1_compute, pos2_compute,
		manip, area,
		data
	)
	local heightmap_orig = wea.table.shallowcopy(heightmap)
	
	local success2, added, removed = wea.sculpt.apply_heightmap(
		brush, brush_size_actual,
		height,
		(heightmap_size / 2):floor(),
		heightmap, heightmap_size
	)
	if not success2 then return success2, added end
	
	-- 3: Save back to disk & return
	local success3, stats = wea.terrain.apply_heightmap_changes(
		pos1_compute, pos2_compute,
		area, data,
		heightmap_orig, heightmap,
		heightmap_size
	)
	if not success3 then return success2, stats end
	
	worldedit.manip_helpers.finish(manip, data)
	
	return true, stats
end


return apply
