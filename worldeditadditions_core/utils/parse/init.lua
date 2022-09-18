-- ██████   █████  ██████  ███████ ███████
-- ██   ██ ██   ██ ██   ██ ██      ██
-- ██████  ███████ ██████  ███████ █████
-- ██      ██   ██ ██   ██      ██ ██
-- ██      ██   ██ ██   ██ ███████ ███████

-- Unified Axes Keyword Parser
local uak_parse = dofile(worldeditadditions.modpath.."/utils/parse/axes_parser.lua")
-- Old axis parsing functions
local axes = dofile(worldeditadditions.modpath.."/utils/parse/axes.lua")

worldeditadditions.parse = {
	direction_keyword = uak_parse.keyword,
	directions = uak_parse.keytable,
	-- Old parse functions (marked for deprecation).
	-- Use parse.keytable or parse.keyword instead
	axes = axes.parse_axes,
	axis_name = axes.parse_axis_name,
}

dofile(worldeditadditions.modpath.."/utils/parse/chance.lua")
dofile(worldeditadditions.modpath.."/utils/parse/map.lua")
dofile(worldeditadditions.modpath.."/utils/parse/seed.lua")
dofile(worldeditadditions.modpath.."/utils/parse/weighted_nodes.lua")
dofile(worldeditadditions.modpath.."/utils/parse/tokenise_commands.lua")
