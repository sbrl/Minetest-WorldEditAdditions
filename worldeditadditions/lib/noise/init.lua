worldeditadditions.noise = {}

-- The command itself
dofile(worldeditadditions.modpath.."/lib/noise/noise2d.lua")

-- Dependencies
dofile(worldeditadditions.modpath.."/lib/noise/apply_2d.lua")
dofile(worldeditadditions.modpath.."/lib/noise/make_2d.lua")
dofile(worldeditadditions.modpath.."/lib/noise/params_apply_default.lua")

-- Noise generation engines
dofile(worldeditadditions.modpath.."/lib/noise/engines/perlin.lua")
