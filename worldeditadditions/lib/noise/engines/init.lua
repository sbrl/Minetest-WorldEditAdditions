local wea = worldeditadditions


return {
	available = { "perlin", "perlinmt", "sin", "white", "red", "infrared" },
	Perlin = dofile(wea.modpath.."/lib/noise/engines/perlin.lua"),
	PerlinMT = dofile(wea.modpath.."/lib/noise/engines/perlinmt.lua"),
	Sin = dofile(wea.modpath.."/lib/noise/engines/sin.lua"),
	White = dofile(wea.modpath.."/lib/noise/engines/white.lua"),
	Red = dofile(wea.modpath.."/lib/noise/engines/red.lua"),
	Infrared = dofile(wea.modpath.."/lib/noise/engines/infrared.lua")
	-- TODO: Follow https://www.redblobgames.com/articles/noise/introduction.html and implement different colours of noise (*especially* red and pink noise)
}
