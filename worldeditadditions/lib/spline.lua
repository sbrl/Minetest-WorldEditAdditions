local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██████  ██      ██ ███    ██ ███████ 
-- ██      ██   ██ ██      ██ ████   ██ ██      
-- ███████ ██████  ██      ██ ██ ██  ██ █████   
--      ██ ██      ██      ██ ██  ██ ██ ██      
-- ███████ ██      ███████ ██ ██   ████ ███████ 

--- Creates a spline that follows the given list of points.
-- @param	pos_list		Vector3[]	The list of points that define the path the spline should follow. Minimum: 2
-- @param	width_start		number	The width of the spline at the start.
-- @param	width_end		number	The width of the spline at the end. If nil, then width_start is used.
-- @param	steps			number		The number of smoothing passes to apply to the list of points.
-- @param	target_node		Vector3		The *normalised* name of the node to use to build the square spiral with.
-- @returns	bool,number|string			A success boolean value, followed by either the number of the nodes set or an error message string.
function worldeditadditions.spline(pos_list, width_start, width_end, steps, target_node)
	if #pos_list < 2 then return false, "Error: At least 2 positions are required to make a spline." end
	if not width_end then width_end = width_start end
	
	---
	-- 0: Find bounding box
	---
	-- We can't use wea_c.pos.get_bounds 'cause that requires a player name
	local pos1, pos2 = pos_list[1], pos_list[2]
	for _, pos in pairs(pos_list) do
		pos1, pos2 = Vector3.expand_region(pos, pos1, pos2)
	end
	local max_width = math.max(width_start, width_end)
	pos1 = pos1 - max_width
	pos2 = pos2 + max_width
	
	
	---
	-- 1: Interpolate points & widths
	---
	local pos_list_chaikin = wea_c.chaikin(pos_list, steps)
	
	local widths_lerped = {}
	for i = 1, #pos_list_chaikin do
		table.insert(
			widths_lerped,
			wea_c.lerp(width_start, width_end, (1/#pos_list_chaikin)*(i-1))
		)
	end
	
	---
	-- 2: Fetch VoxelManipulator, prepare for replacement
	---
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	
	local count = 0 -- The number of nodes replaced
	
	---
	-- 3: Replace nodes
	---
	
	for i = 1, #pos_list_chaikin do
		local pos_next = pos_list_chaikin[i]
		local width_next = widths_lerped[i]
		
		-- For now, just plot a point at each node
		local index_node = area:index(pos_next.x, pos_next.y, pos_next.z)
		data[index_node] = node_id
		
		count = count + 1
	end
	
	---
	-- 4: Save changes and return
	---
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, count
end
