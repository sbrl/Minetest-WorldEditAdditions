local wea = worldeditadditions
local wea_m = wea.modpath .. "/lib/metaballs/"

local playerdata = dofile(wea_m.."playerdata.lua")

local metaballs_ns = {
	render = dofile(wea_m.."render.lua"),
	add = playerdata.add,
	remove = playerdata.remove,
	list = playerdata.list,
	list_pretty = playerdata.list_pretty,
	clear = playerdata.clear,
	volume = playerdata.volume
}

return metaballs_ns
