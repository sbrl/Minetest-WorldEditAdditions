local wea = worldeditadditions


local White = {}
White.__index = White


function White.new(seed)
	local result = {
		seed = seed or math.random()
	}
	setmetatable(result, White)
	return result
end

function White:noise( x, y, z )
	if x == 0 then x = 1 end
	if y == 0 then y = 1 end
	if z == 0 then z = 1 end
	local seed = ((self.seed + (x * y * z)) * 1506359) % 1113883
	
	math.randomseed(seed)
	local value = math.random()
	return value
end

return White
