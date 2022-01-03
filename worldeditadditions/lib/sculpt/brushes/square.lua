
--- Returns a simple square brush with 100% weight for every pixel.
return function(size)
	local result = {}
	for y=0, size.y do
		for x=0, size.x do
			result[y*size.x + x] = 1
		end
	end
	return true, result, size
end
