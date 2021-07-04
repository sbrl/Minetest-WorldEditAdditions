local wea = worldeditadditions

wea.noise = {}

-- The command itself
dofile(wea.modpath.."/lib/noise/run2d.lua")

-- Dependencies
dofile(wea.modpath.."/lib/noise/apply_2d.lua")
dofile(wea.modpath.."/lib/noise/make_2d.lua")
dofile(wea.modpath.."/lib/noise/params_apply_default.lua")

-- Noise generation engines
wea.noise.engines = dofile(wea.modpath.."/lib/noise/engines/init.lua")
