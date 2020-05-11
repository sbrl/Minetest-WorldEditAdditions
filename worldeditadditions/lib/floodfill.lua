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

function Queue.contains(queue, value)
	for i=queue.first,queue.last do
		if queue[i] == value then
			return true
		end
	end
	return false
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

function worldeditadditions.floodfill(start_pos, radius, replace_node)
	-- Calculate the area we want to modify
	local pos1 = vector.add(start_pos, { x = radius, y = 0, z = radius })
	local pos2 = vector.subtract(start_pos, { x = radius, y = radius, z = radius })
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- Setup for the floodfill operation itself
	local start_pos_index = area:index(start_pos.x, start_pos.y, start_pos.z)
	
	local search_id = data[start_pos_index]
	local replace_id = minetest.get_content_id(replace_node)
	local radius_sq = radius*radius
	
	if search_id == replace_id then
		return false
	end
	
	local count = 0
	local remaining_nodes = Queue.new()
	Queue.enqueue(remaining_nodes, start_pos_index)
	
	-- Do the floodfill
	while Queue.is_empty(remaining_nodes) == false do
		local cur = Queue.dequeue(remaining_nodes)
		
		-- Replace this node
		data[cur] = replace_id
		count = count + 1
		
		-- Check all the nearby nodes
		-- We don't need to go upwards here, since we're filling in lake-style
		local xplus = cur + 1 -- +X
		if data[xplus] == search_id and
			worldeditadditions.vector.lengthsquared(vector.subtract(area:position(xplus), start_pos)) < radius_sq and
			not Queue.contains(remaining_nodes, xplus) then
			-- minetest.log("action", "[floodfill] [+X] index " .. xplus .. " is a " .. data[xplus] .. ", searching for a " .. search_id)
			Queue.enqueue(remaining_nodes, xplus)
		end
		local xminus = cur - 1 -- -X
		if data[xminus] == search_id and
			worldeditadditions.vector.lengthsquared(vector.subtract(area:position(xminus), start_pos)) < radius_sq and
			not Queue.contains(remaining_nodes, xminus) then
			-- minetest.log("action", "[floodfill] [-X] index " .. xminus .. " is a " .. data[xminus] .. ", searching for a " .. search_id)
			Queue.enqueue(remaining_nodes, xminus)
		end
		local zplus = cur + area.zstride -- +Z
		if data[zplus] == search_id and
			worldeditadditions.vector.lengthsquared(vector.subtract(area:position(zplus), start_pos)) < radius_sq and
			not Queue.contains(remaining_nodes, zplus) then
			-- minetest.log("action", "[floodfill] [+Z] index " .. zplus .. " is a " .. data[zplus] .. ", searching for a " .. search_id)
			Queue.enqueue(remaining_nodes, zplus)
		end
		local zminus = cur - area.zstride -- -Z
		if data[zminus] == search_id and
			worldeditadditions.vector.lengthsquared(vector.subtract(area:position(zminus), start_pos)) < radius_sq and
			not Queue.contains(remaining_nodes, zminus) then
			-- minetest.log("action", "[floodfill] [-Z] index " .. zminus .. " is a " .. data[zminus] .. ", searching for a " .. search_id)
			Queue.enqueue(remaining_nodes, zminus)
		end
		local yminus = cur - area.ystride -- -Y
		if data[yminus] == search_id and
			worldeditadditions.vector.lengthsquared(vector.subtract(area:position(yminus), start_pos)) < radius_sq and
			not Queue.contains(remaining_nodes, yminus)  then
			-- minetest.log("action", "[floodfill] [-Y] index " .. yminus .. " is a " .. data[yminus] .. ", searching for a " .. search_id)
			Queue.enqueue(remaining_nodes, yminus)
		end
		
		count = count + 1
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return count
end
