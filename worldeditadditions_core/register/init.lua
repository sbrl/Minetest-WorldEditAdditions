-- ██████  ███████  ██████  ██ ███████ ████████ ███████ ██████
-- ██   ██ ██      ██       ██ ██         ██    ██      ██   ██
-- ██████  █████   ██   ███ ██ ███████    ██    █████   ██████
-- ██   ██ ██      ██    ██ ██      ██    ██    ██      ██   ██
-- ██   ██ ███████  ██████  ██ ███████    ██    ███████ ██   ██

-- WorldEditAdditions Register/Overwrite Functions

local we_cm = worldeditadditions_core.modpath .. "/register/"

dofile(we_cm.."check.lua")
dofile(we_cm.."handler.lua")
dofile(we_cm.."register.lua")
dofile(we_cm.."override.lua")
