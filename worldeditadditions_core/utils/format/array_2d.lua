--- Prints a 2d array of numbers formatted like a JS TypedArray (e.g. like a manip node list or a convolutional kernel)
-- In other words, the numbers should be formatted as a single flat array.
-- @param	tbl		number[]	The ZERO-indexed list of numbers
-- @param	width	number		The width of 2D array.
function worldeditadditions.format.array_2d(tbl, width)
	print("==== count: "..(#tbl+1)..", width:"..width.." ====")
	local display_width = 1
	for _i,value in pairs(tbl) do
		display_width = math.max(display_width, #tostring(value))
	end
	display_width = display_width + 2
	local next = {}
	for i=0, #tbl do
		table.insert(next, worldeditadditions.str_padstart(tostring(tbl[i]), display_width))
		if #next == width then
			print(table.concat(next, ""))
			next = {}
		end
	end
end
