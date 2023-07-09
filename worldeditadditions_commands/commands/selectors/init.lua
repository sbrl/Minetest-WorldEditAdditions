-- ███████ ███████ ██      ███████  ██████ ████████  ██████  ██████  ███████
-- ██      ██      ██      ██      ██         ██    ██    ██ ██   ██ ██
-- ███████ █████   ██      █████   ██         ██    ██    ██ ██████  ███████
--      ██ ██      ██      ██      ██         ██    ██    ██ ██   ██      ██
-- ███████ ███████ ███████ ███████  ██████    ██     ██████  ██   ██ ███████

-- Chat commands that operate on selections.

local we_cmdpath = worldeditadditions_commands.modpath .. "/commands/selectors/"

dofile(we_cmdpath.."srel.lua")
dofile(we_cmdpath.."scentre.lua")
dofile(we_cmdpath.."scloud.lua")
dofile(we_cmdpath.."scol.lua")
dofile(we_cmdpath.."scube.lua")
dofile(we_cmdpath.."sfactor.lua")
dofile(we_cmdpath.."smake.lua")
dofile(we_cmdpath.."spop.lua")
dofile(we_cmdpath.."spush.lua")
dofile(we_cmdpath.."srect.lua")
dofile(we_cmdpath.."sshift.lua")
dofile(we_cmdpath.."sstack.lua")
dofile(we_cmdpath.."unmark.lua")

-- Aliases
worldedit.alias_command("sfac", "sfactor")
