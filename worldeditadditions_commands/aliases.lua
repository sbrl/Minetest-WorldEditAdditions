local wea_c = worldeditadditions_core


wea_c.register_alias("smoothadv", "convolve")
wea_c.register_alias("conv", "convolve")

wea_c.register_alias("naturalise", "layers")
wea_c.register_alias("naturalize", "layers")

wea_c.register_alias("flora", "bonemeal")

-- Measure Tools
wea_c.register_alias("mcount", "count")
wea_c.register_alias("mfacing", "mface")


--- Overrides to core WorldEdit commands
-- These are commented out for now, as they could be potentially dangerous to stability
-- Thorough testing is required of our replacement commands before these are uncommented
if minetest.settings:get_bool("worldeditadditions.override_commands", false) then
	worldeditadditions_core.register_alias("copy", "copy+", true)
	worldeditadditions_core.register_alias("move", "move+", true)
	worldeditadditions_core.register_alias("replace", "replacemix", true)
end
