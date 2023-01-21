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
	apply		= dofile(wea_c.modpath.."/utils/table/table_apply.lua"),
	contains	= dofile(wea_c.modpath.."/utils/table/table_contains.lua"),
	deepcopy	= dofile(wea_c.modpath.."/utils/table/deepcopy.lua"),
	filter		= dofile(wea_c.modpath.."/utils/table/table_filter.lua"),
	get_last	= dofile(wea_c.modpath.."/utils/table/table_get_last.lua"),
	makeset		= dofile(wea_c.modpath.."/utils/table/makeset.lua"),
	map			= dofile(wea_c.modpath.."/utils/table/table_map.lua"),
	reduce		= dofile(wea_c.modpath.."/utils/table/table_reduce.lua"),
	shallowcopy	= dofile(wea_c.modpath.."/utils/table/shallowcopy.lua"),
	tostring	= dofile(wea_c.modpath.."/utils/table/table_tostring.lua"),
	unique		= dofile(wea_c.modpath.."/utils/table/table_unique.lua"),
	unpack		= dofile(wea_c.modpath.."/utils/table/table_unpack.lua"),
}
