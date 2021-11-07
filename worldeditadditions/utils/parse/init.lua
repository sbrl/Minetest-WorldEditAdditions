-- ██████   █████  ██████  ███████ ███████
-- ██   ██ ██   ██ ██   ██ ██      ██
-- ██████  ███████ ██████  ███████ █████
-- ██      ██   ██ ██   ██      ██ ██
-- ██      ██   ██ ██   ██ ███████ ███████

local axes = dofile(worldeditadditions.modpath.."/utils/parse/axes.lua")

worldeditadditions.parse = {
	axes = axes.parse_axes,
	axis_name = axes.parse_axis_name
}

dofile(worldeditadditions.modpath.."/utils/parse/chance.lua")
dofile(worldeditadditions.modpath.."/utils/parse/map.lua")
dofile(worldeditadditions.modpath.."/utils/parse/seed.lua")
dofile(worldeditadditions.modpath.."/utils/parse/weighted_nodes.lua")
dofile(worldeditadditions.modpath.."/utils/parse/tokenise_commands.lua")
