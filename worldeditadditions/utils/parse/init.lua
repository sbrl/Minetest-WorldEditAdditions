-- ██████   █████  ██████  ███████ ███████
-- ██   ██ ██   ██ ██   ██ ██      ██
-- ██████  ███████ ██████  ███████ █████
-- ██      ██   ██ ██   ██      ██ ██
-- ██      ██   ██ ██   ██ ███████ ███████

local axes = dofile(worldeditadditions.modpath.."/utils/parse/axes.lua")
local parse = dofile(worldeditadditions.modpath.."/utils/parse/axes.lua")
local key_instance = dofile(worldeditadditions.modpath.."/utils/parse/key_instance.lua")

worldeditadditions.key_instance = key_instance
worldeditadditions.parse = parse

-- Old parse functions (marked for deprecation).
-- Use parse.keytable or parse.keyword instead
worldeditadditions.parse.axes = axes.parse_axes
worldeditadditions.parse.axis_name = axes.parse_axis_name

dofile(worldeditadditions.modpath.."/utils/parse/chance.lua")
dofile(worldeditadditions.modpath.."/utils/parse/map.lua")
dofile(worldeditadditions.modpath.."/utils/parse/seed.lua")
dofile(worldeditadditions.modpath.."/utils/parse/weighted_nodes.lua")
dofile(worldeditadditions.modpath.."/utils/parse/tokenise_commands.lua")
