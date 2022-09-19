local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███████  ██████  █████  ██      ███████         ██    ██ ██████
-- ██      ██      ██   ██ ██      ██              ██    ██ ██   ██
-- ███████ ██      ███████ ██      █████           ██    ██ ██████
--      ██ ██      ██   ██ ██      ██              ██    ██ ██
-- ███████  ██████ ██   ██ ███████ ███████ ███████  ██████  ██

--- Scales the defined region down by the given scale factor in the given directions.
-- @param	pos1		Vector	Position 1 of the defined region,
-- @param	pos2		Vector	Position 2 of the defined region.
-- @param	scale		Vector	The scale factor - as a vector - by which to scale down.
-- @param	anchor		Vector	The direction to scale in - as a vector. e.g. { x = -1, y = 1, z = -1 } would mean scale in the negative x, positive y, and nevative z directions.
-- @return	boolean, string|table	Whether the operation was successful or not. If not, then an error messagea as a string is also passed. If it was, then a statistics object is returned instead.
function worldeditadditions.scale_up(pos1, pos2, scale, anchor)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	if (scale.x < 1 and scale.x > -1) and (scale.y < 1 and scale.y > -1) and (scale.z < 1 and scale.z > -1) then
		return false, "Error: Scale factor vectors may not mix values -1 < factor < 1 and (1 < factor or factor < -1) - in other words, you can't scale both up and down at the same time (try worldeditadditions.scale, which automatically applies such scale factor vectors as 2 successive operations)"
	end
	if anchor.x == 0 or anchor.y == 0 or anchor.z == 0 then
		return false, "Error: One of the components of the anchor vector was 0 (anchor components should either be greater than or less than 0 to indicate the anchor to scale in.)"
	end
	
	local size = (pos2 - pos1) + 1
	
	local pos1_big = Vector3.clone(pos1)
	local pos2_big = Vector3.clone(pos2)
	
	if anchor.x < 1 then pos1_big.x = pos1_big.x - (size.x * (scale.x - 1))
	else pos2_big.x = pos2_big.x + (size.x * (scale.x - 1)) end
	if anchor.y < 1 then pos1_big.y = pos1_big.y - (size.y * (scale.y - 1))
	else pos2_big.y = pos2_big.y + (size.y * (scale.y - 1)) end
	if anchor.z < 1 then pos1_big.z = pos1_big.z - (size.z * (scale.z - 1))
	else pos2_big.z = pos2_big.z + (size.z * (scale.z - 1)) end
	
	local size_big = (pos2_big - pos1_big) + 1
	
	-- print("scale_up: scaling "..pos1.." to "..pos2.." (volume "..worldedit.volume(pos1, pos2).."; size "..size..") to "..pos1_big.." to "..pos2_big.." (volume "..worldedit.volume(pos1_big, pos2_big).."; size "..size_big..")")
	
	local manip_small, area_small = worldedit.manip_helpers.init(pos1, pos2)
	local manip_big, area_big = worldedit.manip_helpers.init(pos1_big, pos2_big)
	local data_source = manip_small:get_data()
	local data_target = manip_big:get_data()
	
	local node_id_air = minetest.get_content_id("air")
	
	local stats = { updated = 0, scale = scale, pos1 = pos1_big, pos2 = pos2_big }
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local posi_rel = Vector3.new(x, y, z) - pos1
				
				local kern_anchor = Vector3.new(
					pos1_big.x + (posi_rel.x * scale.x) + (scale.x - 1),
					pos1_big.y + (posi_rel.y * scale.y) + (scale.y - 1),
					pos1_big.z + (posi_rel.z * scale.z) + (scale.z - 1)
				)
				
				-- print(
				-- 	"posi", Vector3.new(x, y, z)),
				-- 	"posi_rel", posi_rel,
				-- 	"kern_anchor", kern_anchor
				-- )
				
				local source_val = data_source[area_small:index(x, y, z)]
				
				for kz = kern_anchor.z, kern_anchor.z - scale.z + 1, -1 do
					for ky = kern_anchor.y, kern_anchor.y - scale.y + 1, -1 do
						for kx = kern_anchor.x, kern_anchor.x - scale.x + 1, -1 do
							data_target[area_big:index(kx, ky, kz)] = source_val
							stats.updated = stats.updated + 1
						end
					end
				end
				
			end
		end
	end
	
	-- Save the region back to disk & return
	worldedit.manip_helpers.finish(manip_big, data_target)
	
	return true, stats
end
