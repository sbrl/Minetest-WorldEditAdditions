local wea = worldeditadditions
local Vector3 = wea.Vector3

-- ███████ ██████  ██ ██████   █████  ██
-- ██      ██   ██ ██ ██   ██ ██   ██ ██
-- ███████ ██████  ██ ██████  ███████ ██
--      ██ ██      ██ ██   ██ ██   ██ ██
-- ███████ ██      ██ ██   ██ ██   ██ ███████
-- 
--  ██████ ██ ██████   ██████ ██      ███████
-- ██      ██ ██   ██ ██      ██      ██
-- ██      ██ ██████  ██      ██      █████
-- ██      ██ ██   ██ ██      ██      ██
--  ██████ ██ ██   ██  ██████ ███████ ███████


--- Creates a circular spiral that fills the defined region.
-- @param	pos1				Vector3		The 1st position of the defined region.
-- @param	pos2				Vector3		The 2nd position of the defined region.
-- @param	target_node			Vector3		The *normalised* name of the node to use to build the square spiral with.
-- @param	interval_initial	number		The distance between the walls of the spiral.
-- @param	acceleration=0		number		Increate the interval by this number every time we hit a corner of the square spiral.
-- @returns	bool,number|string	A success boolean value, followed by either the number of the nodes set or an error message string.
function worldeditadditions.spiral_circle(pos1, pos2, target_node, interval_initial, acceleration)
	if not acceleration then acceleration = 0 end
	
	pos1, pos2 = Vector3.sort(pos1, pos2)
	local volume = pos2:subtract(pos1)
	local volume_half = volume:divide(2)
	
	print("DEBUG:spiral_square | pos1", pos1, "pos2", pos2, "target_node", target_node, "interval_initial:", interval_initial, "acceleration", acceleration)
	
	interval_initial = interval_initial + 1
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id = minetest.get_content_id(target_node)
	
	local count = 0 -- The number of nodes replaced
	
	local centre = pos2:subtract(pos1):floor():divide(2):add(pos1)
	
	local pos_current = centre:clone():floor()
	local interval = interval_initial
	local radius = 1
	local angle = 0
	-- local sides_acc = 0
	
	while pos_current:is_contained(pos1, pos2) do
		
		for y = pos2.y, pos1.y, -1 do
			data[area:index(
				math.floor(pos_current.x),
				y,
				math.floor(pos_current.z)
			)] = node_id
			count = count + 1
		end
		
		-- print("DEBUG:spiral_circle centre", centre, "bearing", Vector3.fromBearing(angle, 0, radius))
		pos_current = centre:add(Vector3.fromBearing(angle, 0, radius))
		
		local circumference_now = 2 * math.pi * radius
		local step = (math.pi*2)/(circumference_now*2)
		if angle < math.pi then step = step / 10 end
		angle = angle + (step)
		
		local acceleration_constant = 0
		if angle > math.pi / 2 then
			acceleration_constant = (interval/angle * acceleration) * step
		end
		radius = 1 + math.floor(interval*(angle / (math.pi*2)), 0)
		interval = interval_initial + acceleration_constant
		
		
		print("DEBUG cpos", pos_current:multiply(1000):floor():divide(1000), "angle", math.deg(angle), "step", wea.round(math.deg(step), 3), "radius", wea.round(radius, 3), "interval", wea.round(interval, 3), "accel_const", acceleration_constant)
		
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, count
end
