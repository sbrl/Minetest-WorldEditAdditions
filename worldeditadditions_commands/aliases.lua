local wea_c = worldeditadditions_core


wea_c.register_alias("smoothadv", "convolve")
wea_c.register_alias("conv", "convolve")

wea_c.register_alias("naturalise", "layers")
wea_c.register_alias("naturalize", "layers")

wea_c.register_alias("flora", "bonemeal")

-- Measure Tools
wea_c.register_alias("mcount", "count")
wea_c.register_alias("mfacing", "mface")


--- Overrides to core WorldEdit commands that have been thoroughly tested
-- These are now enabled by default, but if you find a bug please report and
-- it will be fixed as a matter of priority.
wea_c.register_alias("copy", "copy+", true)
wea_c.register_alias("move", "move+", true)

--- Overrides to core WorldEdit commands
-- These are disabled by default for now, as they could be potentially dangerous to stability
-- Thorough testing is required of our replacement commands before these are enabled by default
local worldmt_settings = Settings(minetest.get_worldpath().."/world.mt")
local should_override = worldmt_settings:get_bool("worldeditadditions_override_commands", false)
if should_override then
	minetest.log("info", "[WorldEditAdditions] Enabling override aliases")
	wea_c.register_alias("replace", "replacemix", true)
end
