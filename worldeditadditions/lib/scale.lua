
--- Scales the defined region by the given scale factor in the given anchors.
-- Scale factor vectors containing both scale up and scale down operations are
-- split into 2 different scale operations automatically.
-- Scale up operations are always performed before scale down operations to
-- preserve detail. If performance is important, you should split the scale
-- operations up manually!
-- @param	pos1		Vector	Position 1 of the defined region,
-- @param	pos2		Vector	Position 2 of the defined region.
-- @param	scale		Vector	The scale factor - as a vector - by which to scale (values between -1 and 1 are considered a scale down operation).
-- @param	anchor		Vector	The anchor to scale in - as a vector. e.g. { x = -1, y = 1, z = -1 } would mean scale in the negative x, positive y, and negative z directions.
-- @return	boolean, string|table	Whether the operation was successful or not. If not, then an error messagea as a string is also passed. If it was, then a statistics object is returned instead.
function worldeditadditions.scale(pos1, pos2, scale, anchor)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	if scale.x == 0 or scale.y == 0 or scale.z == 0 then
		return false, "A component of the scale factoro was 0."
	end
	
	local scale_down = vector.new(1, 1, 1)
	local scale_up = vector.new(1, 1, 1)
	
	if scale.x > -1 and scale.x < 1 then scale_down.x = scale.x end
	if scale.y > -1 and scale.y < 1 then scale_down.y = scale.y end
	if scale.z > -1 and scale.z < 1 then scale_down.z = scale.z end
	
	if scale.x > 1 or scale.x < -1 then scale_up.x = scale.x end
	if scale.y > 1 or scale.y < -1 then scale_up.y = scale.y end
	if scale.z > 1 or scale.z < -1 then scale_up.z = scale.z end
	
	local stats_total = { updated = 0, operations = 0 }
	
	local success, stats
	if scale_up.x ~= 1 or scale_up.y ~= 1 or scale_up.z ~= 1 then
		success, stats = worldeditadditions.scale_up(pos1, pos2, scale_up, anchor)
		if not success then return success, stats end
		stats_total.updated = stats.updated
		stats_total.operations = stats_total.operations + 1
		stats_total.scale_down = stats.scale
		pos1 = stats.pos1
		pos2 = stats.pos2
	end
	if scale_down.x ~= 1 or scale_down.y ~= 1 or scale_down.z ~= 1 then
		success, stats = worldeditadditions.scale_down(pos1, pos2, scale_down, anchor)
		if not success then return success, stats end
		stats_total.updated = stats_total.updated + stats.updated
		stats_total.operations = stats_total.operations + 1
		pos1 = stats.pos1
		pos2 = stats.pos2
	end
	
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	stats_total.pos1 = pos1
	stats_total.pos2 = pos2
	
	return true, stats_total
end
