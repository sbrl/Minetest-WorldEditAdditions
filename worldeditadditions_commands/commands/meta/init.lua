-- ███    ███ ███████ ████████  █████
-- ████  ████ ██         ██    ██   ██
-- ██ ████ ██ █████      ██    ███████
-- ██  ██  ██ ██         ██    ██   ██
-- ██      ██ ███████    ██    ██   ██

-- Commands that work on other commands.

local we_cmdpath = worldeditadditions_commands.modpath .. "/commands/meta/"

dofile(we_cmdpath.."airapply.lua")
dofile(we_cmdpath.."ellipsoidapply.lua")
dofile(we_cmdpath.."for.lua")
-- dofile(we_cm.."macro.lua") -- Async bug
dofile(we_cmdpath.."many.lua")
dofile(we_cmdpath.."multi.lua")
dofile(we_cmdpath.."noiseapply2d.lua")
dofile(we_cmdpath.."subdivide.lua")

dofile(we_cmdpath.."listentities.lua")