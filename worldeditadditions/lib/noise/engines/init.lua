local wea = worldeditadditions


return {
	available = { "perlin", "sin", "white" },
	Perlin = dofile(wea.modpath.."/lib/noise/engines/perlin.lua"),
	Sin = dofile(wea.modpath.."/lib/noise/engines/sin.lua"),
	White = dofile(wea.modpath.."/lib/noise/engines/white.lua")
	-- TODO: Follow https://www.redblobgames.com/articles/noise/introduction.html and implement different colours of noise (*especially* red and pink noise)
}
