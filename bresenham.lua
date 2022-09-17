local Vector3 = dofile("worldeditadditions/utils/vector3.lua")

local function make_grid(size)
	local grid = {}
	
	for y=1,size.y do
		for x=1,size.x do
			grid[(size.x * y) + x] = 0
		end
	end
	
	return {
		size = size,
		data = grid
	}
end

local function index(grid, pos)
	return (grid.size.x * pos.y) + pos.x
end

local function grid_to_string(grid)
	local result = {}
	for y=1,grid.size.y do
		for x=1,grid.size.x do
			local i = index(grid, Vector3.new(x, y))
			if grid.data[i] == 0 then
				table.insert(result, "#")
			elseif grid.data[i] == 1 then
				table.insert(result, " ")
			elseif grid.data[i] < 10 then
				table.insert(result, tostring(grid.data[i]))
			else
				table.insert(result, "?")
			end
		end
		table.insert(result, "\n")
	end
	
	return table.concat(result, "")
end

--- Draws a line using Bresenham's algorithm in 2d.
-- Implemented ported from https://github.com/anushaihalapathirana/Bresenham-line-drawing-algorithm/blob/f51f153459a1656bfb1f433edc75e6644a052bb2/src/index.js
-- @param	grid	Grid	The grid to draw on.
-- @param	pos1	Vector3	The starting point of the line.
-- @param	pos2	Vector3	The ending point of the line.
-- @param	value	number	The number to fill in grid cells we draw in.
-- @returns	void
local function draw_line_2d(grid, pos1, pos2, value)
	if not value then value = 1 end
	
	if pos1 == pos2 then
		grid.data[index(grid, pos1)] = value
		return
	end
	
	grid.data[index(grid, pos1)] = value -- plot pos1
	local delta = pos2 - pos1
	local absdelta = delta:abs()
	local delta_error = (2 * absdelta.y) - absdelta.x -- d
	if absdelta.x <= absdelta.y then delta_error = (2 * absdelta.x) - absdelta.y end
	
	local pos_current = pos1:clone()
	local steps = 0
	
	local limit = absdelta.y
	if absdelta.x > absdelta.y then limit = absdelta.x end
	
	for _=1,limit do
		local do_x = false
		local do_y = false
		if absdelta.x > absdelta.y then
			do_x = true
			if delta_error < 0 then
				delta_error = delta_error + 2*absdelta.y
			else
				do_y = true
				delta_error = delta_error + (2*absdelta.y - 2*absdelta.x)
			end
		else
			do_y = true
			if delta_error < 0 then
				delta_error = delta_error + 2*absdelta.x
			else
				do_x = true
				delta_error = delta_error + (2*absdelta.x) - (2*absdelta.y)
			end
		end
		
		
		if do_x then
			local acc = 1
			if delta.x < 0 then acc = -1 end
			pos_current.x = pos_current.x + acc
		end
		if do_y then
			local acc = 1
			if delta.y < 0 then acc = -1 end
			pos_current.y = pos_current.y + acc
		end
				
		local i = index(grid, pos_current)
		grid.data[i] = value
		steps = steps + 1
	end
end

local size = Vector3.new(120, 40)
local grid = make_grid(size)



-- draw_line_2d(grid, Vector3.new(10, 10), Vector3.new(40, 10))
-- draw_line_2d(grid, Vector3.new(70, 10), Vector3.new(70, 10))
draw_line_2d(grid, Vector3.new(75, 10), Vector3.new(75, 40))
draw_line_2d(grid, Vector3.new(80, 40), Vector3.new(80, 10))

-- local centre = Vector3.new(25, 25)
-- draw_line_2d(grid, centre, Vector3.new(0, 0))
-- draw_line_2d(grid, centre, Vector3.new(5, 0))
-- draw_line_2d(grid, centre, Vector3.new(10, 0))
-- draw_line_2d(grid, centre, Vector3.new(15, 0))
-- draw_line_2d(grid, centre, Vector3.new(20, 0))
-- draw_line_2d(grid, centre, Vector3.new(25, 0))
-- draw_line_2d(grid, centre, Vector3.new(30, 0), 3)

for i=1,9 do
	print("LINE", i)
	local pos1 = Vector3.new(
		math.random(0, size.x),
		math.random(0, size.y)
	)
	local pos2 = Vector3.new(
		math.random(0, size.x),
		math.random(0, size.y)
	)
	draw_line_2d(grid, pos1, pos2)
end
-- draw_line_2d(grid,
-- 	Vector3.new(3, 4),
-- 	Vector3.new(8, 9)
-- )
-- draw_line_2d(grid,
-- 	Vector3.new(10, 9),
-- 	Vector3.new(15, 4)
-- )
-- draw_line_2d(grid,
-- 	Vector3.new(20, 10),
-- 	Vector3.new(40, 20)
-- )
-- draw_line_2d(grid,
-- 	Vector3.new(10, 9),
-- 	Vector3.new(55, 4)
-- )

print(grid_to_string(grid))
