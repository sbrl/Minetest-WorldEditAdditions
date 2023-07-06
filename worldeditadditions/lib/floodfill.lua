local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


--- Flood-fill command for complex lakes etc.
-- @param	start_pos		Vector3		The position to start floodfilling from.
-- @param	radius			number		The maximum radius to limit the floodfill operation too.
-- @param	replace_node	string		The (normalised) name of the node to replace with when floodfilling.
-- @returns	number			The number of nodes replaced.
function worldeditadditions.floodfill(start_pos, radius, replace_node)
	start_pos = Vector3.clone(start_pos)
	
	-- Calculate the area we want to modify
	local pos1 = start_pos + Vector3.new(radius, 0, radius)
	local pos2 = start_pos - Vector3.new(radius, radius, radius)
	pos1, pos2 = Vector3.sort(pos1, pos2)
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
	local remaining_nodes = wea_c.Queue.new() remaining_nodes:enqueue(start_pos_index)
	
	-- Do the floodfill
	while remaining_nodes:is_empty() == false do
		local cur = remaining_nodes:dequeue()
		
		-- Replace this node
		data[cur] = replace_id
		count = count + 1
		
		-- Check all the nearby nodes
		-- We don't need to go upwards here, since we're filling in lake-style
		local xplus = cur + 1 -- +X
		if data[xplus] == search_id and
			(Vector3.clone(area:position(xplus)) - start_pos):length_squared() < radius_sq and
			not remaining_nodes:contains(xplus) then
			-- minetest.log("action", "[floodfill] [+X] index " .. xplus .. " is a " .. data[xplus] .. ", searching for a " .. search_id)
			remaining_nodes:enqueue(xplus)
		end
		local xminus = cur - 1 -- -X
		if data[xminus] == search_id and
			(Vector3.clone(area:position(xminus)) - start_pos):length_squared() < radius_sq and
			not remaining_nodes:contains(xminus) then
			-- minetest.log("action", "[floodfill] [-X] index " .. xminus .. " is a " .. data[xminus] .. ", searching for a " .. search_id)
			remaining_nodes:enqueue(xminus)
		end
		local zplus = cur + area.zstride -- +Z
		if data[zplus] == search_id and
			(Vector3.clone(area:position(zplus)) - start_pos):length_squared() < radius_sq and
			not remaining_nodes:contains(zplus) then
			-- minetest.log("action", "[floodfill] [+Z] index " .. zplus .. " is a " .. data[zplus] .. ", searching for a " .. search_id)
			remaining_nodes:enqueue(zplus)
		end
		local zminus = cur - area.zstride -- -Z
		if data[zminus] == search_id and
			(Vector3.clone(area:position(zminus)) - start_pos):length_squared() < radius_sq and
			not remaining_nodes:contains(zminus) then
			-- minetest.log("action", "[floodfill] [-Z] index " .. zminus .. " is a " .. data[zminus] .. ", searching for a " .. search_id)
			remaining_nodes:enqueue(zminus)
		end
		local yminus = cur - area.ystride -- -Y
		if data[yminus] == search_id and
			(Vector3.clone(area:position(yminus)) - start_pos):length_squared() < radius_sq and
			not remaining_nodes:contains(yminus)  then
			-- minetest.log("action", "[floodfill] [-Y] index " .. yminus .. " is a " .. data[yminus] .. ", searching for a " .. search_id)
			remaining_nodes:enqueue(yminus)
		end
		
		count = count + 1
	end
	
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return count
end
