
--[[
Convolves over a given 2D heightmap with a given matrix.
Note that this *mutates* the given heightmap.
Note also that the dimensions of the matrix must *only* be odd.
@param	{number[]}			heightmap		The 2D heightmap to convolve over.
@param	{[number,number]}	heightmap_size	The size of the heightmap as [ height, width ]
@param	{number[]}			matrix			The matrix to convolve with.
@param	{[number, number]}	matrix_size		The size of the convolution matrix as [ height, width ]
]]--
function worldeditadditions.conv.convole(heightmap, heightmap_size, matrix, matrix_size)
	if matrix_size[0] % 2 ~= 1 or matrix_size[1] % 2 ~= 1 then
		return false, "Error: The matrix size must contain only odd numbers (even number detected)"
	end
	
	local border_size = {
		(matrix_size[0]-1) / 2,	-- height
		(matrix_size[1]-1) / 2	-- width
	}
	
	-- Convolve over only the bit that allows us to use the full convolution matrix
	for y = heightmap_size[0] - border_size[0], border_size[0], -1 do
		for x = heightmap_size[1] - border_size[1], border_size[1], -1 do
			local total = 0
			
			for my = matrix_size[0], 0, -1 do
				for mx = matrix_size[1], 0, -1 do
					local mi = (my * matrix_size[1]) + mx
					local cy = y + (my - border_size[0])
					local cx = x + (mx - border_size[1])
					
					local i = (cy * heightmap_size[1]) + cx
					
					total = total + matrix[mi] * heightmap[i]
				end
			end
			
			heightmap[(y * heightmap_size[1]) + x] = total
		end
	end
	
	return true, heightmap
end
