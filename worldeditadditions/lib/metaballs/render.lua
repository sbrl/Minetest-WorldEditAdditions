local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███    ███ ███████ ████████  █████  ██████   █████  ██      ██      ███████
-- ████  ████ ██         ██    ██   ██ ██   ██ ██   ██ ██      ██      ██
-- ██ ████ ██ █████      ██    ███████ ██████  ███████ ██      ██      ███████
-- ██  ██  ██ ██         ██    ██   ██ ██   ██ ██   ██ ██      ██           ██
-- ██      ██ ███████    ██    ██   ██ ██████  ██   ██ ███████ ███████ ███████
--- Renders 2 or more metaballs with the given node and threshold value.
-- direction the point should point.
-- @param	metaballs		[{pos: Vector3, radius: number}]	Aa list of metaballs to render. Each metaball should be a table with 2 properties: pos - the position of the centre of the metaball as a Vector3, and radius - the radius of the metaball.
-- @param	replace_node	string		The fully qualified name of the node to use to make the dome with.
local function render(metaballs, replace_node, threshold)
	local pos1, pos2
	if not threshold then threshold = 1 end
	
	for i,metaball in ipairs(metaballs) do
		local pos1_c = metaball.pos - metaball.radius
		local pos2_c = metaball.pos + metaball.radius
		if i == 1 then
			pos1 = pos1_c
			pos2 = pos2_c
		end
		pos1 = Vector3.min(pos1, pos1_c)
		pos2 = Vector3.max(pos2, pos2_c)
	end
	
	-- pos2 will always have the highest co-ordinates now
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_replace = minetest.get_content_id(replace_node)
	
	
	local replaced = 0
	for z = pos2.z, pos1.z, -1 do
		for y = pos2.y, pos1.y, -1 do
			for x = pos2.x, pos1.x, -1 do
				local pos_here = Vector3.new(x, y, z)
				
				local metaball_sum = 0
				for i,metaball in ipairs(metaballs) do
					local distance_sq = (metaball.pos - pos_here):length_squared()
					local radius_sq = metaball.radius * metaball.radius
					local falloff = (1 / (distance_sq/radius_sq)) ^ 2
					metaball_sum = metaball_sum + falloff
				end
				
				if metaball_sum >= threshold then
					data[area:index(x, y, z)] = node_id_replace
					replaced = replaced + 1
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, replaced
end


return render
