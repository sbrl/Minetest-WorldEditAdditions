local wea_c = worldeditadditions_core

local polyfills = dofile(wea_c.modpath.."/utils/strings/polyfill.lua")
for key, value in pairs(polyfills) do
	wea_c[key] = value
end

dofile(wea_c.modpath.."/utils/strings/tochars.lua")
wea_c.split = dofile(wea_c.modpath.."/utils/strings/split.lua")
wea_c.split_shell = dofile(wea_c.modpath.."/utils/strings/split_shell.lua")
wea_c.to_boolean = dofile(wea_c.modpath.."/utils/strings/to_boolean.lua")
