--- Flood-fill command for complex lakes etc.
-- @module worldeditadditions.floodfill

-------------------------------------------------------------------------------
--- A Queue implementation, taken & adapted from https://www.lua.org/pil/11.4.html
-- @submodule worldeditadditions.utils.queue

local Queue = {}
function Queue.new()
	return { first = 0, last = -1 }
end

function Queue.enqueue(queue, value)
	local new_last = queue.last + 1
	queue.last = new_last
	queue[new_last] = value
end

function Queue.is_empty(queue)
	return queue.first > queue.last
end

function Queue.dequeue(queue)
	local first = queue.first
	if Queue.is_empty(queue) then
		error("Error: The queue is empty!")
	end
	
	local value = queue[first]
	queue[first] = nil -- Help the garbage collector out
	queue.first = first + 1
	return value
end

-------------------------------------------------------------------------------


function worldedit.floodfill(start_pos, radius, replace_node)
	-- Calculate the area we want to modify
	local pos1 = vector.add(start_pos, { x = radius, y = 0, z = radius })
	local pos2 = vector.subtract(start_pos, { x = radius, y = radius, z = radius })
	pos1, pos2 = worldedit.sort_pos(pos1, pos2) -- Just in case
	
	minetest.log("action", "radius: " .. radius)
	minetest.log("action", "pos1: (" .. pos1.x .. ", " .. pos1.y .. ", " .. pos1.z .. ")")
	minetest.log("action", "pos2: (" .. pos2.x .. ", " .. pos2.y .. ", " .. pos2.z .. ")")
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- Setup for the floodfill operation itself
	local start_pos_index = area:index(start_pos.x, start_pos.y, start_pos.z);
	
	local search_id = data[start_pos_index]
	local replace_id = minetest.get_content_id(replace_node)
	
	minetest.log("action", "ids: " .. search_id .. " -> " .. replace_id)
	
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
