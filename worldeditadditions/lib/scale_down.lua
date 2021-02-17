-- ███████  ██████  █████  ██      ███████         ██████   ██████  ██     ██ ███    ██
-- ██      ██      ██   ██ ██      ██              ██   ██ ██    ██ ██     ██ ████   ██
-- ███████ ██      ███████ ██      █████           ██   ██ ██    ██ ██  █  ██ ██ ██  ██
--      ██ ██      ██   ██ ██      ██              ██   ██ ██    ██ ██ ███ ██ ██  ██ ██
-- ███████  ██████ ██   ██ ███████ ███████ ███████ ██████   ██████   ███ ███  ██   ████

--- Scales the defined region down by the given scale factor in the given directions.
-- @param	pos1		Vector	Position 1 of the defined region,
-- @param	pos2		Vector	Position 2 of the defined region.
-- @param	scale		Vector	The scale factor - as a vector - by which to scale down.
-- @param	direction	Vector	The direction to scale in - as a vector. e.g. { x = -1, y = 1, z = -1 } would mean scale in the negative x, positive y, and nevative z directions.
-- @return	boolean, string|table	Whether the operation was successful or not. If not, then an error messagea as a string is also passed. If it was, then a statistics object is returned instead.
function worldeditadditions.scale_down(pos1, pos2, scale, direction)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if scale.x > 1 or scale.y > 1 or scale.z > 1 or scale.x < -1 or scale.y < -1 or scale.z < -1 then
		return false, "Error: Scale factor vectors may not mix values -1 < factor < 1 and (1 < factor or factor < -1) - in other words, you can't scale both up and down at the same time (try worldeditadditions.scale, which automatically applies such scale factor vectors as 2 successive operations)"
	end
	if direction.x == 0 or direction.y == 0 or direction.z == 0 then
		return false, "Error: One of the components of the direction vector was 0 (direction components should either be greater than or less than 0 to indicate the direction to scale in.)"
	end
	
	local scale_down = {
		x = math.floor(1 / scale.x),
		y = math.floor(1 / scale.y),
		z = math.floor(1 / scale.z)
	}
	print("[DEBUG] scale_down", worldeditadditions.vector.tostring(scale_down))
	local size = vector.subtract(pos2, pos1)
	
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	local data_copy = worldeditadditions.shallowcopy(data)
	
	local node_id_air = minetest.get_content_id("air")
	
	
	local stats = { updated = 0, scale = "scale_down" }
	-- Zero out the area we're scaling down into
	for i in area:iterp(pos1, pos2) do
		data_copy[i] = node_id_air
		-- We update the entire area, even though we're scaling down
		-- ....because we fill in the area we left behind with air
		stats.updated = stats.updated + 1
	end
	
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local posi_rel = vector.subtract({ x = x, y = y, z = z }, pos1)
				
				local posi_copy = worldeditadditions.shallowcopy(posi_rel)
				posi_copy = vector.floor(vector.divide(scale_down))
				
				if direction.x < 0 then posi_copy.x = size.x - posi_copy.x end
				if direction.y < 0 then posi_copy.y = size.y - posi_copy.y end
				if direction.z < 0 then posi_copy.z = size.z - posi_copy.z end
				
				local posi_copy = vector.add(pos1, posi_copy)
				
				local i_source = area:index(x, y, z)
				local i_target = area:index(posi_copy.x, posi_copy.y, posi_copy.z)
				
				-- Technically we could save some operations here by not setting
				-- the target multiple times per copy, but the calculations
				-- above are probably a lot more taxing
				-- TODO Be more intelligent about deciding what node to replace with here
				data_copy[i_target] = data[i_source]
			end
		end
	end
	
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data_copy)
	
	return true, changes
end
