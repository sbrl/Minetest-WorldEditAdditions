local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

----------------------------------
-- function to print out the world
----------------------------------
local function printspace3d(space, w, h, d)
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

local function generate_maze3d(seed, width, height, depth, path_length, path_width, path_depth)
	
    if not path_length then path_length = 2 end
    if not path_width then path_width = 1 end
	if not path_depth then path_depth = 1 end
	
	-- print("Generating maze "..width.."x"..height.."x"..depth.." | path: length "..path_length.." width "..path_width.." depth "..path_depth)
	math.randomseed(seed) -- seed the random number generator with the system clock

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
        if cz - path_length > 0 and world[cz - path_length][cy][cx] == "#" then
            directions = directions .. "-"
        end
        if cz + path_length < depth-path_depth and world[cz + path_length][cy][cx] == "#" then
            directions = directions .. "+"
        end
		if cy - path_length > 0 and world[cz][cy - path_length][cx] == "#" then
			directions = directions .. "u"
		end
		if cy + path_length < height-path_width and world[cz][cy + path_length][cx] == "#" then
			directions = directions .. "d"
		end
		if cx - path_length > 0 and world[cz][cy][cx - path_length] == "#" then
			directions = directions .. "l"
		end
		if cx + path_length < width-path_width and world[cz][cy][cx + path_length] == "#" then
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
				for iz = cz,cz+path_length+(path_depth-1) do
					for ix = cx,cx+(path_width-1) do
						for iy = cy,cy+(path_width-1) do
							world[iz][iy][ix] = " "
						end
					end
				end
                -- world[cz + 1][cy][cx] = " "
                -- world[cz + 2][cy][cx] = " "
                cz = cz + path_length
            elseif curdir == "-" then
				for iz = cz-path_length,cz do
					for ix = cx,cx+(path_width-1) do
						for iy = cy,cy+(path_width-1) do
							world[iz][iy][ix] = " "
						end
					end
				end
                -- world[cz - 1][cy][cx] = " "
                -- world[cz - 2][cy][cx] = " "
                cz = cz - path_length
            elseif curdir == "u" then
				for iz = cz,cz+(path_depth-1) do
	                for ix = cx,cx+(path_width-1) do
	                    for iy = cy-path_length,cy do
	                        world[iz][iy][ix] = " "
	                    end
	                end
				end
				-- world[cz][cy - 1][cx] = " "
				-- world[cz][cy - 2][cx] = " "
				cy = cy - path_length
			elseif curdir == "d" then
				for iz = cz,cz+(path_depth-1) do
	                for ix = cx,cx+(path_width-1) do
	                    for iy = cy,cy+path_length+(path_width-1) do
	                        world[iz][iy][ix] = " "
							-- print("[tunnel/d] ("..ix..", "..iy..", "..iz..")")
	                    end
	                end
				end
				-- world[cz][cy + 1][cx] = " "
				-- world[cz][cy + 2][cx] = " "
				cy = cy + path_length
			elseif curdir == "l" then
				for iz = cz,cz+(path_depth-1) do
	                for iy = cy,cy+(path_width-1) do
	                    for ix = cx-path_length,cx do
	                        world[iz][iy][ix] = " "
	                    end
	                end
				end
				-- world[cz][cy][cx - 1] = " "
				-- world[cz][cy][cx - 2] = " "
				cx = cx - path_length
			elseif curdir == "r" then
				for iz = cz,cz+(path_depth-1) do
	                for iy = cy,cy+(path_width-1) do
	                    for ix = cx,cx+path_length+(path_width-1) do
	                        world[iz][iy][ix] = " "
	                    end
	                end
				end
				-- world[cz][cy][cx + 1] = " "
				-- world[cz][cy][cx + 2] = " "
				cx = cx + path_length
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
	
	return world
end

-- local world = maze(os.time(), width, height)


--- Generates a 3D maze.
-- **Algorithm origin:** https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html
-- 
-- The defined region must be at least 3 x 3 x 3 (x, y, z) for a maze to generate.
-- @param	pos1			Vector3		pos1 of the defined region to draw the 3D maze in in.
-- @param	pos2			Vector3		pos2 of the defined region to draw the 3D maze in in.
-- @param	target_node		string		The (normalised) node name to draw the maze in.
-- @param	path_length=2	number		Step this many nodes forwards at once when generating the maze.  Higher values create long thin corridors.
-- @param	path_width=1	number		Make all corridors this number of nodes wide when generating the maze. Higher values result in wider corridors.
-- **Caution:** Make sure this value is not higher than `path_length - 1`, otherwise the maze algorithm won't work right!
-- @param	path_depth=1	number		Make all corridors this number of nodes tall when generating the maze. Higher values results in higher ceilings in the maze.
-- **Caution:** The same warning as with `path_width` applies here also!
-- @returns	number			The number of nodes replaced (i.e. the volume fo the region defined by pos1 and pos2).
function worldeditadditions.maze3d(pos1, pos2, target_node, seed, path_length, path_width, path_depth)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- getExtent() returns the number of nodes in the VoxelArea, which might be larger than we actually asked for
	local extent = (pos2 - pos1) + 1
	
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

	-- minetest.log("action", "pos1: " .. pos1)
	-- minetest.log("action", "pos2: " .. pos2)


	-- minetest.log("action", "Generating "..extent.x.."x"..extent.z.."x"..extent.z.." 3d maze from pos1 " .. pos1.." to pos2 "..pos2)

	local maze = generate_maze3d(seed, extent.z, extent.y, extent.x, path_length, path_width, path_depth) -- x & z need to be the opposite way around to how we index it
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
