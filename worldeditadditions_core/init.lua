--- WorldEditAdditions-Core
-- @module worldeditadditions_core
-- @release 1.13
-- @copyright 2021 Starbeamrainbowlabs and VorTechnix
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs and VorTechnix

-- local temp = true
-- if temp then return end
-- This mod isn't finished yet, so it will not be executed for now.


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

dofile(wea_c.modpath.."/utils/strings/init.lua")
dofile(wea_c.modpath.."/utils/format/init.lua")
dofile(wea_c.modpath.."/utils/parse/init.lua")
dofile(wea_c.modpath.."/utils/tables/init.lua")

dofile(wea_c.modpath.."/utils/numbers.lua")
dofile(wea_c.modpath.."/utils/nodes.lua")
dofile(wea_c.modpath.."/utils/node_identification.lua")

dofile(wea_c.modpath.."/utils/raycast_adv.lua") -- For the farwand
dofile(wea_c.modpath.."/utils/player.lua") -- Player info functions






wea_c.pos = dofile(modpath.."/core/pos.lua")
wea_c.register_command = dofile(modpath.."/core/register_command.lua")
wea_c.fetch_command_def = dofile(modpath.."/core/fetch_command_def.lua")
wea_c.register_alias = dofile(modpath.."/core/register_alias.lua")
print("WEA_C pos", wea_c.pos.push)

-- Initialise WorldEdit stuff if the WorldEdit mod is not present
if minetest.global_exists("worldedit") then
	dofile(wea_c.modpath.."/core/integrations/worldedit.lua")
else
	dofile(wea_c.modpath.."/core/integrations/noworldedit.lua")
end
