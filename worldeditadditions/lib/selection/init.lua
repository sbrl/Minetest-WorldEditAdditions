local wea = worldeditadditions
local wea_m = wea.modpath .. "/lib/selection/"

wea.add_pos = {}

wea.selection = dofile(wea_m.."selection.lua")
dofile(wea_m.."stack.lua")
