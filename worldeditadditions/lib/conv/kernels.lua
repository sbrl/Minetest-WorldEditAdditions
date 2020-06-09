--- Creates a (normalised) box convolutional kernel.
-- Larger box kernels will obviously be slower, but will produce a more blurred
-- effect (i.e. smoother terrain).
-- @param	width	number	The width of the kernel.
-- @param	height	number	The height of the kernel.
-- @return	The resulting kernel as a ZERO-indexed list of numbers.
function worldeditadditions.conv.kernel_box(width, height)
	local result = {}
	local total = 0
	for y = 0, height do
		for x = 0, width do
			result[(y*width) + x] = 1
			total = total + 1
		end
	end
	-- Ensure that everything sums up to 1
	for i = 0, #result do
		result[i] = result[i] / total
	end
	return result
end

--- Computes the Lth line of Pascal's triangle.
-- More information: https://en.wikipedia.org/wiki/Pascal%27s_triangle
-- There are probably more efficient ways to it that don't repeat themselves as
-- much, but this is my solution.
-- @param l				number	The 1-indexed row of Pascal's Triangle to return.
-- @return number[]		A ZERO-indexed list of numbers in the specified row of Pascal's Triangle.
local function pascal(l)
	local prev = {}
	prev[0] = 1
	if l == 1 then return prev end
	prev[1] = 1
	if l == 2 then return prev end
	local length_last = 2
	
	for n=3, l do
		local next = {}
		for i=0, length_last do
			if i == 0 or i == length_last then
				next[i] = 1
			else
				next[i] = prev[i - 1] + prev[i]
			end
		end
		prev = next
		length_last = length_last + 1
	end
	return prev
end

--- Creates a pascal convolutional kernel.
-- Larger pascal kernels will obviously be slower, but will produce a more blurred
-- effect (i.e. smoother terrain).
-- @param	width			number	The width of the kernel.
-- @param	height			number	The height of the kernel.
-- @param	normalise=true	bool	Whether to normalise the resulting kernel (default: true)
-- @return	The resulting kernel as a ZERO-indexed list of numbers.
function worldeditadditions.conv.kernel_pascal(width, height, normalise)
	if normalise == nil then normalise = true end
	
	local result = {}
	local pascal_width = width
	local height_middle = ((height - 2) / 2)
	local total = 0
	for y = 0, height-1 do
		local pascal_numbers = pascal(pascal_width)
		local pascal_start = (pascal_width - width) / 2
		for x = 0, width - 1 do
			result[(y*width) + x] = pascal_numbers[pascal_start + x]
			total = total + pascal_numbers[pascal_start + x]
		end
		
		if y > height_middle then pascal_width = pascal_width - 2
		else pascal_width = pascal_width + 2 end
	end
	
	if normalise then
		for k,v in pairs(result) do
			result[k] = result[k] / total
		end
	end
	
	return result
end

-- print("box, 5x5")
-- print_2d(kernel_box(5, 5), 5)
-- print("pascal, 5x5")
-- print_2d(kernel_pascal(5, 5), 5)
-- print("pascal, 7x7")
-- print_2d(kernel_pascal(7, 7), 7)
-- print("pascal, 9x9")
-- print_2d(kernel_pascal(9, 9), 9)
