local wea = worldeditadditions


local Sin = {}
Sin.__index = Sin


function Sin.new()
	local result = {}
	setmetatable(result, Sin)
	return result
end

function Sin:noise( x, y, z )
	-- local value = math.sin(x)
	local value = (math.sin(x) + math.sin(y) + math.sin(z)) / 3
	-- Rescale from -1 - +1 to 0 - 1
	return (value + 1) / 2
end

return Sin
