local wea = worldeditadditions

local White = dofile(wea.modpath.."/lib/noise/engines/white.lua")

local Red = {}
Red.__index = Red


function Red.new(seed)
	local result = {
		seed = seed or math.random(),
		white = White.new(seed)
	}
	setmetatable(result, Red)
	return result
end

function Red:noise( x, y, z )
	local values = {
		self.white:noise(x, y, z),
		self.white:noise(x + 1, y, z),
		self.white:noise(x, y + 1, z),
		self.white:noise(x, y, z + 1),
		self.white:noise(x - 1, y, z),
		self.white:noise(x, y - 1, z),
		self.white:noise(x, y, z - 1),
		self.white:noise(x, y - 1, z - 1),
		self.white:noise(x - 1, y, z - 1),
		self.white:noise(x - 1, y - 1, z),
		self.white:noise(x - 1, y - 1, z - 1),
		self.white:noise(x, y + 1, z + 1),
		self.white:noise(x + 1, y, z + 1),
		self.white:noise(x + 1, y + 1, z),
		self.white:noise(x + 1, y + 1, z + 1),
	}
	return wea.average(values)
end

return Red
