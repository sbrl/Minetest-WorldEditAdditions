local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ██████  ███████ ██    ██  ██████  ██      ██    ██ ███████ 
-- ██   ██ ██      ██    ██ ██    ██ ██      ██    ██ ██      
-- ██████  █████   ██    ██ ██    ██ ██      ██    ██ █████   
-- ██   ██ ██       ██  ██  ██    ██ ██       ██  ██  ██      
-- ██   ██ ███████   ████    ██████  ███████   ████   ███████ 

--- Make <times> copies of the region defined by pos1-pos2 at equal angles around a circle.
-- The defined region works best if it's a thin slice that's 1 or 2 blocks thick.
-- For example, if one provided a times value of 3, copies would be rotated 0, 120, and 240 degrees.
-- TODO: implement support to rotate around arbitrary axes.
-- @param	pos1	Vector3		The first position defining the source region.
-- @param	pos2	Vector3		The second position defining the source region.
-- @param	origin	Vector3		The pivot point to rotate around.
-- @param	times	number		The number of equally-spaces copies to make.
function worldeditadditions.revolve(pos1, pos2, origin, times)
	local rotation_radians = wea_c.table.filter(
		wea_c.range(0, 1, 1 / times),
		function (val) return val ~= 0 and val ~= 1 end
	)
	
	local pos1_source, pos2_source = Vector3.sort(pos1, pos2)
	
	-- HACK: with some maths this could be much more efficient.
	local pos1_target, pos2_target = wea_c.table.unpack(wea_c.table.reduce({
		Vector3.rotate3d(origin, pos1_source, Vector3.new(0, math.pi / 2, 0)),
		Vector3.rotate3d(origin, pos2_source, Vector3.new(0, math.pi / 2, 0)),
		Vector3.rotate3d(origin, pos1_source, Vector3.new(0, math.pi, 0)),
		Vector3.rotate3d(origin, pos2_source, Vector3.new(0, math.pi, 0)),
		Vector3.rotate3d(origin, pos1_source, Vector3.new(0, -math.pi / 2, 0)),
		Vector3.rotate3d(origin, pos2_source, Vector3.new(0, -math.pi / 2, 0)),
	}, function(acc, next)
		return { next:expand_region(acc[1], acc[2]) }
	end, { pos1_source, pos2_source }))
	
	-- Fetch the nodes in the specified area
	local manip_source, area_source = worldedit.manip_helpers.init(pos1_source, pos2_source)
	local data_source = manip_source:get_data()
	
	local manip_target, area_target = worldedit.manip_helpers.init(pos1_target, pos2_target)
	local data_target = manip_target:get_data()
	
	local changed = 0
	for z = pos2_source.z, pos1_source.z, -1 do
		for y = pos2_source.y, pos1_source.y, -1 do
			for x = pos2_source.x, pos1_source.x, -1 do
				local pos_source = Vector3.new(x, y, z)
				local i_source = area_source:index(x, y, z)
				
				-- Lua really sucks sometimes... a continue statement would be v useful here
				if not wea_c.is_airlike(data_source[i_source]) then
					for index, rotation in ipairs(rotation_radians) do
						local pos_target = Vector3.rotate3d(
							origin,
							pos_source,
							-- rotate on Z axis only, convert 0..1 → radians
							-- TEST on Y axis, 'cause I'm confused
							Vector3.new(0, rotation * math.pi * 2, 0)
						):round()
						
						local i_target = area_target:index(pos_target.x, pos_target.y, pos_target.z)
						
						-- TODO: Rotate notes as appropriate
						data_target[i_target] = data_source[i_source]
						changed = changed + 1
					end
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip_target, data_target)

	return true, changed
end