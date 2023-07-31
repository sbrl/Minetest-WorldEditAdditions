--- WorldEditAdditions-Core
-- @namespace worldeditadditions_core
-- @release 1.14.5
-- @copyright 2021 Starbeamrainbowlabs and VorTechnix
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs and VorTechnix


local modpath = minetest.get_modpath("worldeditadditions_core")

worldeditadditions_core = {
	modpath = modpath,
	registered_commands = {},
	-- Storage for per-player node limits before safe_region kicks in.
	-- TODO: Persist these to disk.
	safe_region_limits = {},
	-- The default limit for new players on the number of potential nodes changed before safe_region kicks in.
	safe_region_limit_default = 100000,
}
local wea_c = worldeditadditions_core
wea_c.EventEmitter = dofile(modpath.."/utils/EventEmitter.lua")


wea_c.Set = dofile(wea_c.modpath.."/utils/set.lua")

wea_c.Vector3 = dofile(wea_c.modpath.."/utils/vector3.lua")
wea_c.Mesh, wea_c.Face = dofile(wea_c.modpath.."/utils/mesh.lua")

wea_c.Queue = dofile(wea_c.modpath.."/utils/queue.lua")
wea_c.LRU = dofile(wea_c.modpath.."/utils/lru.lua")
wea_c.inspect = dofile(wea_c.modpath.."/utils/inspect.lua")

-- I/O compatibility layer
wea_c.io = dofile(wea_c.modpath.."/utils/io.lua")

wea_c.bit = dofile(wea_c.modpath.."/utils/bit.lua")

wea_c.terrain = dofile(wea_c.modpath.."/utils/terrain/init.lua")

local chaikin = dofile(wea_c.modpath.."/utils/chaikin.lua")
wea_c.chaikin = chaikin.chaikin
wea_c.lerp = chaikin.linear_interpolate

dofile(wea_c.modpath.."/utils/strings/init.lua")
dofile(wea_c.modpath.."/utils/format/init.lua")
dofile(wea_c.modpath.."/utils/parse/init.lua")
dofile(wea_c.modpath.."/utils/table/init.lua")

dofile(wea_c.modpath.."/utils/numbers.lua")
dofile(wea_c.modpath.."/utils/nodes.lua")
dofile(wea_c.modpath.."/utils/node_identification.lua")

dofile(wea_c.modpath.."/utils/raycast_adv.lua") -- For the farwand
dofile(wea_c.modpath.."/utils/player.lua") -- Player info functions



wea_c.setting_handler = dofile(wea_c.modpath.."/utils/setting_handler.lua") -- AFTER parser

wea_c.pos = dofile(modpath.."/core/pos.lua") -- AFTER EventEmitter
wea_c.register_command = dofile(modpath.."/core/register_command.lua")
wea_c.fetch_command_def = dofile(modpath.."/core/fetch_command_def.lua")
wea_c.register_alias = dofile(modpath.."/core/register_alias.lua")
wea_c.entities = dofile(modpath.."/core/entities/init.lua") -- AFTER pos
dofile(modpath.."/core/pos_marker_manage.lua") -- AFTER pos, entities
dofile(modpath.."/core/pos_marker_wall_manage.lua") -- AFTER pos, entities

-- Initialise WorldEdit stuff if the WorldEdit mod is not present
if minetest.global_exists("worldedit") then
	dofile(wea_c.modpath.."/core/integrations/worldedit.lua")
else
	dofile(wea_c.modpath.."/core/integrations/noworldedit.lua")
end
