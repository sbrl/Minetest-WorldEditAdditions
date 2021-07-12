local wea = worldeditadditions


return {
	available = { "perlin", "sin", "white", "red" },
	Perlin = dofile(wea.modpath.."/lib/noise/engines/perlin.lua"),
	Sin = dofile(wea.modpath.."/lib/noise/engines/sin.lua"),
	White = dofile(wea.modpath.."/lib/noise/engines/white.lua"),
	Red = dofile(wea.modpath.."/lib/noise/engines/red.lua")
	-- TODO: Follow https://www.redblobgames.com/articles/noise/introduction.html and implement different colours of noise (*especially* red and pink noise)
}
