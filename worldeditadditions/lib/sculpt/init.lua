local wea = worldeditadditions

local sculpt = {
	brushes = {
		circle_soft1 = dofile(wea.modpath.."/lib/sculpt/brushes/circle_soft1.lua"),
		circle = dofile(wea.modpath.."/lib/sculpt/brushes/circle.lua"),
		square = dofile(wea.modpath.."/lib/sculpt/brushes/square.lua"),
		gaussian_hard = dofile(wea.modpath.."/lib/sculpt/brushes/gaussian_hard.lua"),
		gaussian = dofile(wea.modpath.."/lib/sculpt/brushes/gaussian.lua"),
		gaussian_soft = dofile(wea.modpath.."/lib/sculpt/brushes/gaussian_soft.lua"),
	},
	make_brush = dofile(wea.modpath.."/lib/sculpt/make_brush.lua"),
	make_preview = dofile(wea.modpath.."/lib/sculpt/make_preview.lua"),
	preview_brush = dofile(wea.modpath.."/lib/sculpt/preview_brush.lua"),
	read_brush_static = dofile(wea.modpath.."/lib/sculpt/read_brush_static.lua"),
	apply_heightmap = dofile(wea.modpath.."/lib/sculpt/apply_heightmap.lua"),
	apply = dofile(wea.modpath.."/lib/sculpt/apply.lua"),
	scan_static = dofile(wea.modpath.."/lib/sculpt/scan_static.lua"),
	import_static = dofile(wea.modpath.."/lib/sculpt/import_static.lua"),
	parse_static = dofile(wea.modpath.."/lib/sculpt/parse_static.lua")
}

-- scan_sculpt is called after everything is loaded in the main init file

return sculpt

-- TODO: Automatically find & register all text file based brushes in the brushes directory

-- TODO: Implement automatic scaling of static brushes to the correct size. We have scale already, but we probably need to implement a proper 2d canvas scaling algorithm. Some options to consider: linear < [bi]cubic < nohalo/lohalo

-- Note that we do NOT automatically find & register computed brushes because that's an easy way to execute arbitrary Lua code & cause a security issue unless handled very carefully
