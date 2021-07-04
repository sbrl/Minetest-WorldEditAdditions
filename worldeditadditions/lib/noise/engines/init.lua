local wea = worldeditadditions


return {
	Perlin = dofile(wea.modpath.."/lib/noise/engines/perlin.lua"),
	Sin = dofile(wea.modpath.."/lib/noise/engines/sin.lua")
	
	-- TODO: Follow https://www.redblobgames.com/articles/noise/introduction.html and implement different colours of noise (*especially* red and pink noise)
}
