local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ██      ██ ███    ██ ███████
-- ██      ██ ████   ██ ██
-- ██      ██ ██ ██  ██ █████
-- ██      ██ ██  ██ ██ ██
-- ███████ ██ ██   ████ ███████

--- Counts the nodes in a given area.
-- @param	pos1		Vector3		The position to start drawing the line from.
-- @param	pos2		Vector3		The position to draw the line to.
-- @param	thickness	number		The thickness of the line to draw.
-- @param	node_name	string		The (normalised) name of the node to draw the line with.
-- @returns	bool,{replaced=number}	1. A bool indicating whether the operation was successful or not.
-- 									2. A table containing statistics. At present the only key in this table is `replaced`, which indicates the number of nodes replaced when drawing the line.
function worldeditadditions.line(pos1, pos2, thickness, node_name)
	local pos1_sorted, pos2_sorted = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	pos1 = Vector3.clone(pos1)
	pos2 = Vector3.clone(pos2)
	
	local node_id_replace = minetest.get_content_id(node_name)
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	local counts = { replaced = 0 }
	for z = pos2_sorted.z, pos1_sorted.z, -1 do
		for x = pos2_sorted.x, pos1_sorted.x, -1 do
			for y = pos2_sorted.y, pos1_sorted.y, -1 do
				local here = Vector3.new(x, y, z)
				local D = (pos2 - pos1):normalise()
				local d = Vector3.dot(here - pos1, D)
				local closest_on_line = pos1 + (D * d)
				local distance = (here - closest_on_line):length()
				
				if distance < thickness then
					data[area:index(x, y, z)] = node_id_replace
					counts.replaced = counts.replaced + 1
				end
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, counts
end
