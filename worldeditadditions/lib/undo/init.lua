local wea = worldeditadditions
local wea_m = wea.modpath .. "/lib/undo/"

wea.undo = {}
wea.undo.Action = dofile(wea_m.."Action.lua")
wea.undo.ActionsStack = dofile(wea_m.."ActionsStack.lua") -- depends on Action
