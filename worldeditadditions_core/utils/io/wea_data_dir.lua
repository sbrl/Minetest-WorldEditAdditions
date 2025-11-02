local weac = worldeditadditions_core

-- CAUTION: This file needs loading AFTER weac.dirsep is defined! (this shouldn't be an issue).

-- Initialize the WEA world folder if it doesn't already exist
local dirpath_wea_data = minetest.get_worldpath() .. weac.dirsep .. "worldeditadditions"
minetest.mkdir(dirpath_wea_data)

return dirpath_wea_data
