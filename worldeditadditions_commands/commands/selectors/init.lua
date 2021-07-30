-- ███████ ███████ ██      ███████  ██████ ████████  ██████  ██████  ███████
-- ██      ██      ██      ██      ██         ██    ██    ██ ██   ██ ██
-- ███████ █████   ██      █████   ██         ██    ██    ██ ██████  ███████
--      ██ ██      ██      ██      ██         ██    ██    ██ ██   ██      ██
-- ███████ ███████ ███████ ███████  ██████    ██     ██████  ██   ██ ███████

-- Chat commands that operate on selections.

local we_cm = worldeditadditions_commands.modpath .. "/commands/selectors/"

dofile(we_cm.."srel.lua")
dofile(we_cm.."scentre.lua")
dofile(we_cm.."scloud.lua")
dofile(we_cm.."scol.lua")
dofile(we_cm.."scube.lua")
dofile(we_cm.."sfactor.lua")
dofile(we_cm.."smake.lua")
dofile(we_cm.."spop.lua")
dofile(we_cm.."spush.lua")
dofile(we_cm.."srect.lua")
dofile(we_cm.."sshift.lua")
dofile(we_cm.."sstack.lua")

-- Aliases
worldedit.alias_command("sfac", "sfactor")
