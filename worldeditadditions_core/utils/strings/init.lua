local wea_c = worldeditadditions_core

dofile(wea_c.modpath.."/utils/strings/split.lua")
dofile(wea_c.modpath.."/utils/strings/polyfill.lua")
dofile(wea_c.modpath.."/utils/strings/tochars.lua")
wea_c.split_shell = dofile(wea_c.modpath.."/utils/strings/split_shell.lua")
wea_c.to_boolean = dofile(wea_c.modpath.."/utils/strings/to_boolean.lua")
