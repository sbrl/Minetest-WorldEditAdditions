-- ███████  ██████  █████  ██      ███████         ██████   ██████  ██     ██ ███    ██
-- ██      ██      ██   ██ ██      ██              ██   ██ ██    ██ ██     ██ ████   ██
-- ███████ ██      ███████ ██      █████           ██   ██ ██    ██ ██  █  ██ ██ ██  ██
--      ██ ██      ██   ██ ██      ██              ██   ██ ██    ██ ██ ███ ██ ██  ██ ██
-- ███████  ██████ ██   ██ ███████ ███████ ███████ ██████   ██████   ███ ███  ██   ████

--- Scales the defined region down by the given scale factor in the given directions.
-- @param	pos1		Vector	Position 1 of the defined region,
-- @param	pos2		Vector	Position 2 of the defined region.
-- @param	scale		Vector	The scale factor - as a vector - by which to scale down.
-- @param	anchor		Vector	The direction to scale in - as a vector. e.g. { x = -1, y = 1, z = -1 } would mean scale in the negative x, positive y, and nevative z directions.
-- @return	boolean, string|table	Whether the operation was successful or not. If not, then an error messagea as a string is also passed. If it was, then a statistics object is returned instead.
function worldeditadditions.scale_down(pos1, pos2, scale, anchor)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if scale.x > 1 or scale.y > 1 or scale.z > 1 or scale.x < -1 or scale.y < -1 or scale.z < -1 then
		return false, "Error: Scale factor vectors may not mix values -1 < factor < 1 and (1 < factor or factor < -1) - in other words, you can't scale both up and down at the same time (try worldeditadditions.scale, which automatically applies such scale factor vectors as 2 successive operations)"
	end
	if anchor.x == 0 or anchor.y == 0 or anchor.z == 0 then
		return false, "Error: One of the components of the anchor vector was 0 (anchor components should either be greater than or less than 0 to indicate the anchor to scale in.)"
	end
	
	local scale_down = {
		x = math.floor(1 / scale.x),
		y = math.floor(1 / scale.y),
		z = math.floor(1 / scale.z)
	}
	local size = vector.subtract(pos2, pos1)
	
	if size.x < scale_down.x or size.y < scale_down.y or size.z < scale.z then
		return false, "Error: Area isn't big enough to apply scale down by "..worldeditadditions.vector.tostring(scale).."."
	end
	
	local size_small = {
		x = math.floor(size.x / scale_down.x),
		y = math.floor(size.y / scale_down.y),
		z = math.floor(size.z / scale_down.z)
	}
	
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	local data_copy = worldeditadditions.table.shallowcopy(data)
	
	local node_id_air = minetest.get_content_id("air")
	
	local pos1_small = vector.new(pos1)
	local pos2_small = vector.new(pos2)
	
	if anchor.x < 1 then pos1_small.x = pos2_small.x - size_small.x
	else pos2_small.x = pos1_small.x + size_small.x end
	if anchor.y < 1 then pos1_small.y = pos2_small.y - size_small.y
	else pos2_small.y = pos1_small.y + size_small.y end
	if anchor.z < 1 then pos1_small.z = pos2_small.z - size_small.z
	else pos2_small.z = pos1_small.z + size_small.z end
	
	
	local stats = { updated = 0, scale = scale_down, pos1 = pos1_small, pos2 = pos2_small }
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
				
				-- local posi_copy = worldeditadditions.table.shallowcopy(posi_rel)
				-- posi_copy = vector.floor(vector.divide(posi_rel/*, scale_down*/))
				
				local posi_copy = {
					x = math.floor(posi_rel.x / scale_down.x),
					y = math.floor(posi_rel.y / scale_down.y),
					z = math.floor(posi_rel.z / scale_down.z)
				}
				
				if anchor.x < 0 then posi_copy.x = size.x - posi_copy.x end
				if anchor.y < 0 then posi_copy.y = size.y - posi_copy.y end
				if anchor.z < 0 then posi_copy.z = size.z - posi_copy.z end
				
				posi_copy = vector.add(pos1, posi_copy)
				
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
	
	return true, stats
end
