local core = worldeditadditions_core


core.register_alias("smoothadv", "convolve")
core.register_alias("conv", "convolve")

core.register_alias("naturalise", "layers")
core.register_alias("naturalize", "layers")

-- Commands prefixed with n affect nodes
core.register_alias("napply", "nodeapply")

if core.command_exists("/bonemeal") then
	-- No need to log here, since we notify the server admin in the server logs in the dofile() for the main //bonemeal command
	core.register_alias("flora", "bonemeal")
end

-- Measure Tools
core.register_alias("mcount", "count")
core.register_alias("mfacing", "mface")


--- Overrides to core WorldEdit commands that have been thoroughly tested
-- These are now enabled by default, but if you find a bug please report and
-- it will be fixed as a matter of priority.
core.register_alias("copy", "copy+", true)
core.register_alias("move", "move+", true)

--- Overrides to core WorldEdit commands
-- These are disabled by default for now, as they could be potentially dangerous to stability
-- Thorough testing is required of our replacement commands before these are enabled by default
local worldmt_settings = Settings(minetest.get_worldpath().."/world.mt")
local should_override = worldmt_settings:get_bool("worldeditadditions_override_commands", false)
if should_override then
	minetest.log("info", "[WorldEditAdditions] Enabling override aliases")
	core.register_alias("replace", "replacemix", true)
end
