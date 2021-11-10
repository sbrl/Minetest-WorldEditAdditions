-- ████████  █████  ██████  ██      ███████ ███████
--    ██    ██   ██ ██   ██ ██      ██      ██
--    ██    ███████ ██████  ██      █████   ███████
--    ██    ██   ██ ██   ██ ██      ██           ██
--    ██    ██   ██ ██████  ███████ ███████ ███████

-- Functions that operate on tables.
-- Lua doesn't exactly come with batteries included, so this is quite an
-- extensive collection of functions :P

local wea = worldeditadditions

wea.table = {
	apply		= dofile(wea.modpath.."/utils/tables/table_apply.lua"),
	contains	= dofile(wea.modpath.."/utils/tables/table_contains.lua"),
	deepcopy	= dofile(wea.modpath.."/utils/tables/deepcopy.lua"),
	filter		= dofile(wea.modpath.."/utils/tables/table_filter.lua"),
	get_last	= dofile(wea.modpath.."/utils/tables/table_get_last.lua"),
	makeset		= dofile(wea.modpath.."/utils/tables/makeset.lua"),
	map			= dofile(wea.modpath.."/utils/tables/table_map.lua"),
	shallowcopy	= dofile(wea.modpath.."/utils/tables/shallowcopy.lua"),
	tostring	= dofile(wea.modpath.."/utils/tables/table_tostring.lua"),
	unique		= dofile(wea.modpath.."/utils/tables/table_unique.lua"),
	unpack		= dofile(wea.modpath.."/utils/tables/table_unpack.lua"),
}
