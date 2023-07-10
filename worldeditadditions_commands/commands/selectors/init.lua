-- ███████ ███████ ██      ███████  ██████ ████████  ██████  ██████  ███████
-- ██      ██      ██      ██      ██         ██    ██    ██ ██   ██ ██
-- ███████ █████   ██      █████   ██         ██    ██    ██ ██████  ███████
--      ██ ██      ██      ██      ██         ██    ██    ██ ██   ██      ██
-- ███████ ███████ ███████ ███████  ██████    ██     ██████  ██   ██ ███████

-- Chat commands that operate on selections.

local wea_cmdpath = worldeditadditions_commands.modpath .. "/commands/selectors/"
local weac = worldeditadditions_core

dofile(wea_cmdpath.."srel.lua")
dofile(wea_cmdpath.."scentre.lua")
dofile(wea_cmdpath.."scloud.lua")
dofile(wea_cmdpath.."scol.lua")
dofile(wea_cmdpath.."scube.lua")
dofile(wea_cmdpath.."sfactor.lua")
dofile(wea_cmdpath.."smake.lua")
dofile(wea_cmdpath.."spop.lua")
dofile(wea_cmdpath.."spush.lua")
dofile(wea_cmdpath.."srect.lua")
dofile(wea_cmdpath.."sshift.lua")
dofile(wea_cmdpath.."sstack.lua")

dofile(wea_cmdpath.."unmark.lua")
dofile(wea_cmdpath.."mark.lua")
dofile(wea_cmdpath.."pos1-2.lua")
dofile(wea_cmdpath.."reset.lua")

-- Aliases
weac.register_alias("sfac", "sfactor")

weac.register_alias("1", "pos1", true) -- true = override target
weac.register_alias("2", "pos2", true) -- true = override target
