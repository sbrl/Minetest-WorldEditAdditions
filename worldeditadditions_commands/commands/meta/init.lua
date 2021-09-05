-- ███    ███ ███████ ████████  █████
-- ████  ████ ██         ██    ██   ██
-- ██ ████ ██ █████      ██    ███████
-- ██  ██  ██ ██         ██    ██   ██
-- ██      ██ ███████    ██    ██   ██

-- Commands that work on other commands.

local we_cm = worldeditadditions_commands.modpath .. "/commands/meta/"

dofile(we_cm.."airapply.lua")
dofile(we_cm.."ellipsoidapply.lua")
dofile(we_cm.."for.lua")
-- dofile(we_cm.."macro.lua") -- Async bug
dofile(we_cm.."many.lua")
dofile(we_cm.."multi.lua")
dofile(we_cm.."noiseapply2d.lua")
dofile(we_cm.."subdivide.lua")
