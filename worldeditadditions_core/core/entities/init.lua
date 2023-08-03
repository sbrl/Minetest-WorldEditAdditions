-- ███████ ███    ██ ████████ ██ ████████ ██ ███████ ███████ 
-- ██      ████   ██    ██    ██    ██    ██ ██      ██      
-- █████   ██ ██  ██    ██    ██    ██    ██ █████   ███████ 
-- ██      ██  ██ ██    ██    ██    ██    ██ ██           ██ 
-- ███████ ██   ████    ██    ██    ██    ██ ███████ ███████ 

local wea_c = worldeditadditions_core

--- Entities and functions to manage them.
-- @namespace worldeditadditions_core.entities
return {
	pos_marker		= dofile(wea_c.modpath.."/core/entities/pos_marker.lua"),
	pos_marker_wall	= dofile(wea_c.modpath.."/core/entities/pos_marker_wall.lua")
}