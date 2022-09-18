-- ████████  █████  ██████  ██      ███████ ███████
--    ██    ██   ██ ██   ██ ██      ██      ██
--    ██    ███████ ██████  ██      █████   ███████
--    ██    ██   ██ ██   ██ ██      ██           ██
--    ██    ██   ██ ██████  ███████ ███████ ███████

-- Functions that operate on tables.
-- Lua doesn't exactly come with batteries included, so this is quite an
-- extensive collection of functions :P

local wea_c = worldeditadditions_core

wea_c.table = {
	apply		= dofile(wea_c.modpath.."/utils/tables/table_apply.lua"),
	contains	= dofile(wea_c.modpath.."/utils/tables/table_contains.lua"),
	deepcopy	= dofile(wea_c.modpath.."/utils/tables/deepcopy.lua"),
	filter		= dofile(wea_c.modpath.."/utils/tables/table_filter.lua"),
	get_last	= dofile(wea_c.modpath.."/utils/tables/table_get_last.lua"),
	makeset		= dofile(wea_c.modpath.."/utils/tables/makeset.lua"),
	map			= dofile(wea_c.modpath.."/utils/tables/table_map.lua"),
	shallowcopy	= dofile(wea_c.modpath.."/utils/tables/shallowcopy.lua"),
	tostring	= dofile(wea_c.modpath.."/utils/tables/table_tostring.lua"),
	unique		= dofile(wea_c.modpath.."/utils/tables/table_unique.lua"),
	unpack		= dofile(wea_c.modpath.."/utils/tables/table_unpack.lua"),
}
