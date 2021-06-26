-- ████████  █████  ██████  ██      ███████ ███████
--    ██    ██   ██ ██   ██ ██      ██      ██
--    ██    ███████ ██████  ██      █████   ███████
--    ██    ██   ██ ██   ██ ██      ██           ██
--    ██    ██   ██ ██████  ███████ ███████ ███████

-- Functions that operate on tables.
-- Lua doesn't exactly come with batteries included, so this is quite an
-- extensive collection of functions :P

-- TODO: Refactor into its own worldeditadditions.tables namespace.
worldeditadditions.tables = {}

dofile(worldeditadditions.modpath.."/utils/tables/sets.lua")
dofile(worldeditadditions.modpath.."/utils/tables/shallowcopy.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_apply.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_filter.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_get_last.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_map.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_tostring.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_unique.lua")
dofile(worldeditadditions.modpath.."/utils/tables/table_unpack.lua")
