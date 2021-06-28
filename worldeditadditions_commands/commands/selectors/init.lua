-- ███████ ███████ ██      ███████  ██████ ████████  ██████  ██████  ███████
-- ██      ██      ██      ██      ██         ██    ██    ██ ██   ██ ██
-- ███████ █████   ██      █████   ██         ██    ██    ██ ██████  ███████
--      ██ ██      ██      ██      ██         ██    ██    ██ ██   ██      ██
-- ███████ ███████ ███████ ███████  ██████    ██     ██████  ██   ██ ███████

-- Chat commands that operate on selections.

local we_c = worldeditadditions_commands
we_c.modpath = minetest.get_modpath("worldeditadditions_commands")

dofile(we_c.modpath.."/commands/selectors/srel.lua")
dofile(we_c.modpath.."/commands/selectors/scentre.lua")
dofile(we_c.modpath.."/commands/selectors/scloud.lua")
dofile(we_c.modpath.."/commands/selectors/scol.lua")
dofile(we_c.modpath.."/commands/selectors/scube.lua")
dofile(we_c.modpath.."/commands/selectors/sfactor.lua")
dofile(we_c.modpath.."/commands/selectors/smake.lua")
dofile(we_c.modpath.."/commands/selectors/spop.lua")
dofile(we_c.modpath.."/commands/selectors/spush.lua")
dofile(we_c.modpath.."/commands/selectors/srect.lua")
dofile(we_c.modpath.."/commands/selectors/sstack.lua")
