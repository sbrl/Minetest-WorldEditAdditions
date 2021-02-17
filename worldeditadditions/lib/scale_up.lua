-- ███████  ██████  █████  ██      ███████         ██    ██ ██████
-- ██      ██      ██   ██ ██      ██              ██    ██ ██   ██
-- ███████ ██      ███████ ██      █████           ██    ██ ██████
--      ██ ██      ██   ██ ██      ██              ██    ██ ██
-- ███████  ██████ ██   ██ ███████ ███████ ███████  ██████  ██

--- Scales the defined region down by the given scale factor in the given directions.
-- @param	pos1		Vector	Position 1 of the defined region,
-- @param	pos2		Vector	Position 2 of the defined region.
-- @param	scale		Vector	The scale factor - as a vector - by which to scale down.
-- @param	direction	Vector	The direction to scale in - as a vector. e.g. { x = -1, y = 1, z = -1 } would mean scale in the negative x, positive y, and nevative z directions.
-- @return	boolean, string|table	Whether the operation was successful or not. If not, then an error messagea as a string is also passed. If it was, then a statistics object is returned instead.
function worldeditadditions.scale_up(pos1, pos2, scale, direction)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if (scale.x < 1 and scale.x > -1) and (scale.y < 1 and scale.y > -1) and (scale.z < 1 and scale.z > -1) then
		return false, "Error: Scale factor vectors may not mix values -1 < factor < 1 and (1 < factor or factor < -1) - in other words, you can't scale both up and down at the same time (try worldeditadditions.scale, which automatically applies such scale factor vectors as 2 successive operations)"
	end
	if direction.x == 0 or direction.y == 0 or direction.z == 0 then
		return false, "Error: One of the components of the direction vector was 0 (direction components should either be greater than or less than 0 to indicate the direction to scale in.)"
	end
	
	local size = vector.subtract(pos2, pos1)
	
	local pos1_big = vector.new(pos1)
	local pos2_big = vector(pos2)
	
	if direction.x < 1 then pos1_big.x = pos1_big.x - size.x
	else pos2_big.x = pos2_big.x + size.x end
	if direction.y < 1 then pos1_big.y = pos1_big.y - size.y
	else pos2_big.y = pos2_big.y + size.y end
	if direction.z < 1 then pos1_big.z = pos1_big.z - size.z
	else pos2_big.z = pos2_big.z + size.z end
	
	
	
	local manip_small, area_small = worldedit.manip_helpers.init(pos1, pos2)
	local manip_big, area_big = worldedit.manip_helpers.init(pos1_big, pos2_big)
	local data_source = manip_small:get_data()
	local data_target = manip_big:get_data()
	
	local node_id_air = minetest.get_content_id("air")
	
	local kern_volume = math.abs(scale.x) * math.abs(scale.y) * math.abs(scale.z)
	
	local changes = { updated = 0, scale = "scale_up" }
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local posi_rel = vector.subtract({ x = x, y = y, z = z }, pos1)
				
				local kern_anchor = vector.add(
					pos1_big,
					vector.cross(
						vector.add(posi_rel, 1),
						scale
					)
				)
				
				local source_val = data_source[area_small:index(x, y, z)]
				
				for kz = kern_anchor.z, kern_anchor.z - scale.z, -1 do
					for ky = kern_anchor.y, kern_anchor.y - scale.y, -1 do
						for kx = kern_anchor.x, kern_anchor.x - scale.x, -1 do
							data_target[area_big:index(kx, ky, kz)] = source_val
						end
					end
				end
				
				changes.updated = changes.updated + kern_volume
			end
		end
	end
	
	-- Save the region back to disk & return
	worldedit.manip_helpers.finish(manip_big, data_target)
	
	return true, changes
end
