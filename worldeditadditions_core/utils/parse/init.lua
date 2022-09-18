local wea_c = worldeditadditions_core

-- ██████   █████  ██████  ███████ ███████
-- ██   ██ ██   ██ ██   ██ ██      ██
-- ██████  ███████ ██████  ███████ █████
-- ██      ██   ██ ██   ██      ██ ██
-- ██      ██   ██ ██   ██ ███████ ███████

-- Unified Axes Keyword Parser
local uak_parse = dofile(wea_c.modpath.."/utils/parse/axes_parser.lua")
-- Old axis parsing functions
local axes = dofile(wea_c.modpath.."/utils/parse/axes.lua")

wea_c.parse = {
	direction_keyword = uak_parse.keyword,
	directions = uak_parse.keytable,
	-- Old parse functions (marked for deprecation).
	-- Use parse.keytable or parse.keyword instead
	axes = axes.parse_axes,
	axis_name = axes.parse_axis_name,
	
	seed = dofile(wea_c.modpath.."/utils/parse/seed.lua"),
	chance = dofile(wea_c.modpath.."/utils/parse/chance.lua"),
	map = dofile(wea_c.modpath.."/utils/parse/map.lua"),
	weighted_nodes = dofile(wea_c.modpath.."/utils/parse/weighted_nodes.lua")
}

dofile(wea_c.modpath.."/utils/parse/tokenise_commands.lua")
