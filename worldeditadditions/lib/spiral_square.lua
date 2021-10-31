local wea = worldeditadditions
local Vector3 = wea.Vector3

-- ███████ ██████  ██ ██████   █████  ██
-- ██      ██   ██ ██ ██   ██ ██   ██ ██
-- ███████ ██████  ██ ██████  ███████ ██
--      ██ ██      ██ ██   ██ ██   ██ ██
-- ███████ ██      ██ ██   ██ ██   ██ ███████
-- 
-- ███████  ██████  ██    ██  █████  ██████  ███████
-- ██      ██    ██ ██    ██ ██   ██ ██   ██ ██
-- ███████ ██    ██ ██    ██ ███████ ██████  █████
--      ██ ██ ▄▄ ██ ██    ██ ██   ██ ██   ██ ██
-- ███████  ██████   ██████  ██   ██ ██   ██ ███████
--             ▀▀

--- Creates a square spiral that fills the defined region.
-- @param	pos1			Vector3		The 1st position of the defined region.
-- @param	pos2			Vector3		The 2nd position of the defined region.
-- @param	target_node		Vector3		The *normalised* name of the node to use to build the square spiral with.
-- @param	interval		number		The distance between the walls of the spiral.
-- @param	acceleration=0	number		Increate the interval by this number every time we hit a corner of the square spiral.
-- @returns	bool,number|string			A success boolean value, followed by either the number of the nodes set or an error message string.
function worldeditadditions.spiral_square(pos1, pos2, target_node, interval, acceleration)
	if not acceleration then acceleration = 0 end
	
	pos1, pos2 = Vector3.sort(pos1, pos2)
	local volume = pos2:subtract(pos1)
	local volume_half = volume:divide(2)
	
	print("DEBUG:spiral_square | pos1: "..pos1..", pos2: "..pos2..", target_node: "..target_node, "interval:"..interval..", acceleration: "..acceleration)
	
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	
	local count = 0 -- The number of nodes replaced
	
	local centre = pos2:subtract(pos1):floor():divide(2):add(pos1)
	
	local pos_current = centre:clone():floor()
	local side_length = 0
	local direction = Vector3.new(1, 0, 0)
	local side_length_max = interval + 1
	local sides_complete = 0
	-- local sides_acc = 0
	
	while pos_current:is_contained(pos1, pos2) do
		
		for y = pos2.y, pos1.y, -1 do
			data[area:index(pos_current.x, y, pos_current.z)] = node_id
			count = count + 1
		end
		
		pos_current = pos_current:add(direction)
		side_length = side_length + 1
		
		print("DEBUG cpos", pos_current, "side_length", side_length, "side_length_max", side_length_max, "direction", direction)
		
		if side_length >= side_length_max then
			sides_complete = sides_complete + 1
			-- sides_acc = sides_acc + 1
			if sides_complete % 2 == 0 then
				-- sides_acc = 0
				side_length_max = side_length_max + interval + acceleration + 1
			end
			side_length = 0
			
			if direction.x == 0 and direction.z == 1 then
				direction.x = 1
				direction.z = 0
			elseif direction.x == 1 and direction.z == 0 then
				direction.x = 0
				direction.z = -1
			elseif direction.x == 0 and direction.z == -1 then
				direction.x = -1
				direction.z = 0
			else
				direction.x = 0
				direction.z = 1
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, count
end
