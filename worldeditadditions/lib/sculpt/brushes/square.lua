
--- Returns a simple square brush with 100% weight for every pixel.
-- @name square
-- @param	size		Vector3		The desired size of the brush. Only the x and y components are used; the z component is ignored.
-- @returns bool,number[],Vector3	1: true, as this function always succeeds. 2: A simple square brush as a zero-indexed flat array. 3: The size of the resulting brush as a Vector3, using the x and y components.
return function(size)
	local result = {}
	for y=0, size.y do
		for x=0, size.x do
			result[y*size.x + x] = 1
		end
	end
	return true, result, size
end
