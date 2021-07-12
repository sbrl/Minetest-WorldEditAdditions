local wea = worldeditadditions

local White = dofile(wea.modpath.."/lib/noise/engines/white.lua")

local Infrared = {}
Infrared.__index = Infrared


function Infrared.new(seed)
	local result = {
		seed = seed or math.random(),
		white = White.new(seed),
		window = 2
	}
	setmetatable(result, Infrared)
	return result
end

function Infrared:noise( x, y, z )
	local values = { }
	for nx=x-self.window,x+self.window do
		for ny=y-self.window,y+self.window do
			for nz=z-self.window,z+self.window do
				table.insert(values, self.white:noise(nx, ny, nz))
			end
		end
	end
	return wea.average(values)
end

return Infrared
