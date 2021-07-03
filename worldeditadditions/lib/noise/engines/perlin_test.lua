local Perlin = require("perlin")

--- Pads str to length len with char from left
-- Adapted from the above
local function str_padstart(str, len, char)
	if char == nil then char = ' ' end
	return string.rep(char, len - #str) .. str
end
local function array_2d(tbl, width)
	print("==== count: "..(#tbl+1)..", width:"..width.." ====")
	local display_width = 1
	for _i,value in pairs(tbl) do
		display_width = math.max(display_width, #tostring(value))
	end
	display_width = display_width + 2
	local next = {}
	for i=0, #tbl do
		table.insert(next, str_padstart(tostring(tbl[i]), display_width))
		if #next == width then
			print(table.concat(next, ""))
			next = {}
		end
	end
end


--- Finds the minimum value in the given list.
-- @param	list	number[]	The list (table) of numbers to find the minimum value of.
-- @returns	number	The minimum value in the given list.
function min(list)
	if #list == 0 then return nil end
	local min = nil
	for i,value in ipairs(list) do
		if min == nil or min > value then
			min = value
		end
	end
	return min
end

--- Finds the maximum value in the given list.
-- @param	list	number[]	The list (table) of numbers to find the maximum value of.
-- @returns	number	The maximum value in the given list.
function max(list)
	if #list == 0 then return nil end
	local max = nil
	for i,value in ipairs(list) do
		if max == nil or max < value then
			max = value
		end
	end
	return max
end


local p = Perlin.new()

local result = {}
local size = { x = 10, z = 25 }

for x = 0, size.x do
	for y = 0, size.z do
		result[y*size.x + x] = p:noise(x, y, 0)
	end
end

print(array_2d(result, size.x))

print("MAX ", max(result))
print("MIN ", min(result))
