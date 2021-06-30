-- ██████  ███████  ██████  ██ ███████ ████████ ███████ ██████
-- ██   ██ ██      ██       ██ ██         ██    ██      ██   ██
-- ██████  █████   ██   ███ ██ ███████    ██    █████   ██████
-- ██   ██ ██      ██    ██ ██      ██    ██    ██      ██   ██
-- ██   ██ ███████  ██████  ██ ███████    ██    ███████ ██   ██

-- WorldEditAdditions Register/Overwrite Functions

--TODO: Replicate chatcommand_handler functionality (worldedit_commands/init.lua line 21-60)

local we_cm = worldeditadditions_core.modpath .. "/register/"

dofile(we_cm.."check.lua")
dofile(we_cm.."register.lua")
dofile(we_cm.."override.lua")
