--- Generates a maze.
-- Algorithm origin: https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html
-- @module worldeditadditions.maze

----------------------------------
-- function to print out the world
----------------------------------
function printspace3d(space, w, h, d)
	for z = 0, d - 1, 1 do
		for y = 0, h - 1, 1 do
			local line = ""
			for x = 0, w - 1, 1 do
				line = line .. space[z][y][x]
			end
			print(line)
		end
        print("")
	end
end

-- Initialise the world
start_time = os.clock()

function generate_maze3d(seed, width, height, depth)
	start_time = os.clock()
	
	print("Generating maze "..width.."x"..height.."x"..depth)
	math.randomseed(seed) -- seed the random number generator with the system clock

	width = width - 1
	height = height - 1

	local world = {}
	for z = 0, depth, 1 do
        world[z] = {}
		for y = 0, height, 1 do
			world[z][y] = {}
			for x = 0, width, 1 do
				world[z][y][x] = "#"
			end
		end
	end

	-- do a random walk to create pathways
	local nodes = {} -- the nodes left that we haven't investigated
	local curnode = 1 -- the node we are currently operating on
	local cx, cy, cz = 1, 1, 1 -- our current position
	table.insert(nodes, { x = cx, y = cy, z = cz })
	world[cz][cy][cx] = " "
	while #nodes > 0 do
		-- io.write("Nodes left: " .. curnode .. "\r")
		--print("Nodes left: " .. #nodes)

		local directions = "" -- the different directions we can move in
        if cz - 2 > 0 and world[cz - 2][cy][cx] == "#" then
            directions = directions .. "-"
        end
        if cz + 2 < depth and world[cz + 2][cy][cx] == "#" then
            directions = directions .. "+"
        end
		if cy - 2 > 0 and world[cz][cy - 2][cx] == "#" then
			directions = directions .. "u"
		end
		if cy + 2 < height and world[cz][cy + 2][cx] == "#" then
			directions = directions .. "d"
		end
		if cx - 2 > 0 and world[cz][cy][cx - 2] == "#" then
			directions = directions .. "l"
		end
		if cx + 2 < width and world[cz][cy][cx + 2] == "#" then
			directions = directions .. "r"
		end
		
		-- If this is 1 or less, then we will switch our attention to another candidate node after moving
		local shift_attention = math.random(0, 3)
        
		--print("radar output: '" .. directions .. "' (length: " .. #directions .. "), curnode: " .. curnode)
		if #directions > 0 then
			-- we still have somewhere that we can go
			local curdirnum = math.random(1, #directions)
			local curdir = string.sub(directions, curdirnum, curdirnum)
            
            if curdir == "+" then
                world[cz + 1][cy][cx] = " "
                world[cz + 2][cy][cx] = " "
                cz = cz + 2
            elseif curdir == "-" then
                world[cz - 1][cy][cx] = " "
                world[cz - 2][cy][cx] = " "
                cz = cz - 2
            elseif curdir == "u" then
				world[cz][cy - 1][cx] = " "
				world[cz][cy - 2][cx] = " "
				cy = cy - 2
			elseif curdir == "d" then
				world[cz][cy + 1][cx] = " "
				world[cz][cy + 2][cx] = " "
				cy = cy + 2
			elseif curdir == "l" then
				world[cz][cy][cx - 1] = " "
				world[cz][cy][cx - 2] = " "
				cx = cx - 2
			elseif curdir == "r" then
				world[cz][cy][cx + 1] = " "
				world[cz][cy][cx + 2] = " "
				cx = cx + 2
			end
            
			table.insert(nodes, { x = cx, y = cy, z = cz })
		else
			table.remove(nodes, curnode)
		end
		
		if #directions == 0 or shift_attention <= 1 then
			if #nodes > 0 then
				curnode = math.random(1, #nodes)
				
				cx = nodes[curnode]["x"]
				cy = nodes[curnode]["y"]
                cz = nodes[curnode]["z"]
			end
		end
	end
	
	end_time = os.clock()
	
	return world
end

-- local world = maze(os.time(), width, height)

function worldedit.maze3d(pos1, pos2, target_node, seed)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- getExtent() returns the number of nodes in the VoxelArea, which might be larger than we actually asked for
	local extent = {
		x = (pos2.x - pos1.x) + 1,
		y = (pos2.y - pos1.y) + 1,
		z = (pos2.z - pos1.z) + 1
	}
	-- minetest.log("action", "extent: ("..extent.x..", "..extent.y..", "..extent.z..")")
	
	if extent.x < 3 or extent.y < 3 or extent.z < 3 then
		minetest.log("info", "[worldeditadditions/maze] error: either x, y, or z of the extent were less than 3")
		return 0
	end

	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()

	local node_id_air = minetest.get_content_id("air")
	local node_id_target = minetest.get_content_id(target_node)

	-- minetest.log("action", "pos1: " .. worldeditadditions.vector.tostring(pos1))
	-- minetest.log("action", "pos2: " .. worldeditadditions.vector.tostring(pos2))


	minetest.log("action", "Generating "..extent.x.."x"..extent.z.."x"..extent.z.." 3d maze from pos1 " .. worldeditadditions.vector.tostring(pos1).." to pos2 "..worldeditadditions.vector.tostring(pos2))

	local maze = generate_maze3d(seed, extent.z, extent.y, extent.x) -- x &   need to be the opposite way around to how we index it
	-- printspace3d(maze, extent.z, extent.y, extent.x)

	-- z y x is the preferred loop order, but that isn't really possible here

	for z = pos2.z, pos1.z, - 1 do
		for x = pos2.x, pos1.x, - 1 do
			for y = pos2.y, pos1.y, - 1 do
				local maze_x = (x - pos1.x) -- - 1
				local maze_y = (y - pos1.y) -- - 1
				local maze_z = (z - pos1.z) -- - 1
				if maze_x < 0 then maze_x = 0 end
				if maze_y < 0 then maze_y = 0 end
				if maze_z < 0 then maze_z = 0 end
				
				-- minetest.log("action", "x: "..x..", y: "..y..", z: "..z..", pos x: "..maze_x..", pos z: "..maze_z)
				-- minetest.log("action", "value: "..maze[maze_x][maze_y][maze_z])
				
				if maze[maze_x][maze_y][maze_z] == "#" then
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
