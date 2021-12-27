--- Generates a maze.
-- Algorithm origin: https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html
-- @module worldeditadditions.maze


----------------------------------
-- function to print out the world
----------------------------------
local function printspace(space, w, h)
	for y = 0, h - 1, 1 do
		local line = ""
		for x = 0, w - 1, 1 do
			line = line .. space[y][x]
		end
		minetest.log("action", line)
	end
end

local function generate_maze(seed, width, height, path_length, path_width)
	local start_time = worldeditadditions.get_ms_time()
	
    if not path_length then path_length = 2 end
    if not path_width then path_width = 1 end
    
	-- minetest.log("action", "width: "..width..", height: "..height)
	math.randomseed(seed) -- seed the random number generator with the system clock

	width = width - 1
	height = height - 1
	
	local world = {}
	for y = 0, height, 1 do
		world[y] = {}
		for x = 0, width, 1 do
			world[y][x] = "#"
		end
	end
    
	-- do a random walk to create pathways
	local nodes = {} -- the nodes left that we haven't investigated
	local curnode = 1 -- the node we are currently operating on
	local cx, cy = 1, 1 -- our current position
	table.insert(nodes, { x = cx, y = cy })
	world[cy][cx] = " "
	while #nodes > 0 do
		
		local directions = "" -- the different directions we can move
		if cy - path_length > 0 and world[cy - path_length][cx] == "#" then
			directions = directions .. "u"
		end
		if cy + path_length < height-path_width+1 and world[cy + path_length][cx] == "#" then
			directions = directions .. "d"
		end
		if cx - path_length > 0 and world[cy][cx - path_length] == "#" then
			directions = directions .. "l"
		end
		if cx + path_length < width-path_width+1 and world[cy][cx + path_length] == "#" then
			directions = directions .. "r"
		end
		
		local shift_attention = math.random(0, 9)
		
		if #directions > 0 then
			-- we still have somewhere that we can go
			--print("This node is not a dead end yet.")
			local curdirnum = math.random(1, #directions)
			local curdir = string.sub(directions, curdirnum, curdirnum)
			if curdir == "u" then
                for ix = cx,cx+(path_width-1) do
                    for iy = cy-path_length,cy do
                        world[iy][ix] = " "
                    end
                end
				cy = cy - path_length
			elseif curdir == "d" then
                for ix = cx,cx+path_width-1 do
                    for iy = cy,cy+path_length+(path_width-1) do
                        world[iy][ix] = " "
                    end
                end
				cy = cy + path_length
			elseif curdir == "l" then
                for iy = cy,cy+path_width-1 do
                    for ix = cx-path_length,cx do
                        world[iy][ix] = " "
                    end
                end
				cx = cx - path_length
			elseif curdir == "r" then
                for iy = cy,cy+(path_width-1) do
                    for ix = cx,cx+path_length+(path_width-1) do
                        world[iy][ix] = " "
                    end
                end
				cx = cx + path_length
			end
			
			table.insert(nodes, { x = cx, y = cy })
		else
			table.remove(nodes, curnode)
		end
		
		if #directions == 0 or shift_attention <= 1 then
			if #nodes > 0 then
				--print("performing teleport.");
				curnode = math.random(1, #nodes)
				cx = nodes[curnode]["x"]
				cy = nodes[curnode]["y"]
			end
		end
	end
    
	local end_time = worldeditadditions.get_ms_time()
	return world, (end_time - start_time) * 1000
end

-- local world = maze(os.time(), width, height)

function worldeditadditions.maze2d(pos1, pos2, target_node, seed, path_length, path_width)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- getExtent() returns the number of nodes in the VoxelArea, which might be larger than we actually asked for
	local extent = {
		x = (pos2.x - pos1.x) + 1, path_length, path_width,
		y = (pos2.y - pos1.y) + 1, -- not a dimension passed to the maze generator itself
		z = (pos2.z - pos1.z) + 1, path_length, path_width
	}
	-- minetest.log("action", "extent: ("..extent.x..", "..extent.y..", "..extent.z..")")
	
	if extent.x < 3 or extent.y < 1 or extent.z < 3 then
		minetest.log("error", "[worldeditadditions/maze] error: either x, y of the extent were less than 3, or z of the extent was less than 1")
		return 0
	end

	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()

	local node_id_air = minetest.get_content_id("air")
	local node_id_target = minetest.get_content_id(target_node)

	-- print("pos1: ", worldeditadditions.vector.tostring(pos1))
	-- print("pos2: ", worldeditadditions.vector.tostring(pos2))


	-- minetest.log("action", "Generating "..extent.x.."x"..extent.z.." maze (depth "..extent.z..") from pos1 " .. worldeditadditions.vector.tostring(pos1).." to pos2 "..worldeditadditions.vector.tostring(pos2))
	-- print("path_width: "..path_width..", path_length: "..path_length)

	local maze = generate_maze(seed, extent.z, extent.x, path_length, path_width) -- x &   need to be the opposite way around to how we index it
	-- printspace(maze, extent.z, extent.x)

	-- z y x is the preferred loop order, but that isn't really possible here

	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			for y = pos2.y, pos1.y, -1 do
				local maze_x = (x - pos1.x) -- - 1
				local maze_z = (z - pos1.z) -- - 1
				if maze_x < 0 then maze_x = 0 end
				if maze_z < 0 then maze_z = 0 end
				
				-- minetest.log("action", "x: "..x..", y: "..y..", z: "..z..", pos x: "..maze_x..", pos z: "..maze_z)
				-- minetest.log("action", "value: "..maze[maze_x][maze_z])
				
				if maze[maze_x][maze_z] == "#" then
					data[area:index(x, y, z)] = node_id_target
				else
					data[area:index(x, y, z)] = node_id_air
				end
			end
		end
	end

	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)

	return extent.x * extent.y * extent.z
end
