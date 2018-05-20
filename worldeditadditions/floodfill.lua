--- Flood-fill command for complex lakes etc.
-- @module worldeditadditions.floodfill

local Queue = require "queue"

local function floodfill(start_pos, radius, replace_node)
	-- Calculate the area we want to modify
	local pos1, pos2 = centre_pos
	pos1.x = pos1.x - radius
	pos1.z = pos1.z - radius
	pos2.x = pos2.x + radius
	pos2.y = pos2.y + radius
	pos2.z = pos2.z + radius
	pos1, pos2 = worldedit.sort_pos(pos1, pos2) -- Just in case
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init()
	local data = manip:get_data()
	
	-- Setup for the floodfill operation itself
	local start_pos_index = area:index(start_pos.x, start_pos.y, start_pos.z);
	
	local search_id = data[start_pos_index]
	local replace_id = minetest.get_content_id(replace_node)
	
	local count = 0
	local remaining_nodes = Queue.new()
	Queue.enqueue(remaining_nodes, start_pos_index)
	
	-- Do the floodfill
	while Queue.is_empty(remaining_nodes) == false do
		local cur = Queue.dequeue(remaining_nodes)
		
		-- TODO: Check distance from start_pos
		
		-- Replace this node
		data[cur] = replace_id
		count = count + 1
			
		-- Check all the nearby nodes
		-- We don't need to go upwards here, since we're filling in lake-style
		if data[cur + 1] == search_id then -- +X
			Queue.enqueue(remaining_nodes, cur + 1)
		end
		if data[cur - 1] == search_id then -- -X
			Queue.enqueue(remaining_nodes, cur - 1)
		end
		if data[cur + area.zstride] == search_id then -- +Z
			Queue.enqueue(remaining_nodes, cur + area.zstride)
		end
		if data[cur - area.zstride] == search_id then -- -Z
			Queue.enqueue(remaining_nodes, cur - area.zstride)
		end
		if data[cur - area.ystride] == search_id then -- -Y
			Queue.enqueue(remaining_nodes, cur - area.ystride)
		end
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return count
end


return floodfill
