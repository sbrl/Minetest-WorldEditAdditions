local wea_c = worldeditadditions_core


wea_c.format = {
	array_2d = dofile(wea_c.modpath.."/utils/format/array_2d.lua"),
	human_size = dofile(wea_c.modpath.."/utils/format/human_size.lua"),
	human_time = dofile(wea_c.modpath.."/utils/format/human_time.lua"),
	node_distribution = dofile(wea_c.modpath.."/utils/format/node_distribution.lua"),
	make_ascii_table = dofile(wea_c.modpath.."/utils/format/make_ascii_table.lua"),
	map = dofile(wea_c.modpath.."/utils/format/map.lua"),
}

