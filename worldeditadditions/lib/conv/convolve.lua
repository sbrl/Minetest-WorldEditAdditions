local wea = worldeditadditions
local Vector3 = wea.Vector3
--[[
Convolves over a given 2D heightmap with a given matrix.
Note that this *mutates* the given heightmap.
Note also that the dimensions of the matrix must *only* be odd.
@param	{number[]}	heightmap		The 2D heightmap to convolve over.
@param	Vector3		heightmap_size	The size of the heightmap as an X/Z Vector3 instance.
@param	{number[]}	matrix			The matrix to convolve with.
@param	Vector3		matrix_size		The size of the convolution matrix as an X/Z Vector3 instance.
]]--
function worldeditadditions.conv.convolve(heightmap, heightmap_size, matrix, matrix_size)
	if matrix_size.x % 2 ~= 1 or matrix_size.z % 2 ~= 1 then
		return false, "Error: The matrix size must contain only odd numbers (even number detected)"
	end
	
	-- We need to reference a *copy* of the heightmap when convolving
	-- This is because we need the original values when we perform a
	-- convolution on a given pixel
	local heightmap_copy = wea.table.shallowcopy(heightmap)
	
	local border_size = Vector3.new(
		(matrix_size.x-1) / 2,		-- x = height
		0,
		(matrix_size.z-1) / 2		-- z = width
	)
	-- print("[convolve] matrix_size", matrix_size.x, matrix_size.z)
	-- print("[convolve] border_size", border_size.x, border_size.z)
	-- print("[convolve] heightmap_size: ", heightmap_size.z, heightmap_size.x)
	-- 
	-- print("[convolve] z: from", (heightmap_size.z-border_size.x) - 1, "to", border_size.x, "step", -1)
	-- print("[convolve] x: from", (heightmap_size.x-border_size.z) - 1, "to", border_size.z, "step", -1)
	
	-- Convolve over only the bit that allows us to use the full convolution matrix
	for z = (heightmap_size.z-border_size.x) - 1, border_size.x, -1 do
		for x = (heightmap_size.x-border_size.z) - 1, border_size.z, -1 do
			local total = 0
			
			
			local hi = (z * heightmap_size.x) + x
			-- print("[convolve/internal] z", z, "x", x, "hi", hi)
			
			-- No continue statement in Lua :-/
			if heightmap_copy[hi] ~= -1 then
				for mz = matrix_size.x-1, 0, -1 do
					for mx = matrix_size.z-1, 0, -1 do
						local mi = (mz * matrix_size.z) + mx
						local cz = z + (mz - border_size.x)
						local cx = x + (mx - border_size.z)
						
						local i = (cz * heightmap_size.x) + cx
						
						-- A value of -1 = nothing in this column (so we should ignore it)
						if heightmap_copy[i] ~= -1 then
							total = total + (matrix[mi] * heightmap_copy[i])
						end
					end
				end
				
				-- Rounding hack - ref https://stackoverflow.com/a/18313481/1460422
				-- heightmap[hi] = math.floor(total + 0.5)
				heightmap[hi] = math.ceil(total)
			end
		end
	end
	
	return true, heightmap
end
