local wea = worldeditadditions

local sculpt = {
	brushes = {
		default_hard = dofile(wea.modpath.."/lib/sculpt/brushes/default_hard.lua"),
		default = dofile(wea.modpath.."/lib/sculpt/brushes/default.lua"),
		default_soft = dofile(wea.modpath.."/lib/sculpt/brushes/default_soft.lua"),
		square = dofile(wea.modpath.."/lib/sculpt/brushes/square.lua")
	},
	make_brush = dofile(wea.modpath.."/lib/sculpt/make_brush.lua"),
	preview_brush = dofile(wea.modpath.."/lib/sculpt/preview_brush.lua"),
	read_brush_static = dofile(wea.modpath.."/lib/sculpt/read_brush_static.lua"),
	apply_heightmap = dofile(wea.modpath.."/lib/sculpt/apply_heightmap.lua"),
	apply = dofile(wea.modpath.."/lib/sculpt/apply.lua")
}

return sculpt

-- TODO: Automatically find & register all text file based brushes in the brushes directory

-- TODO: Implement automatic scaling of static brushes to the correct size. We have scale already, but we probably need to implement a proper 2d canvas scaling algorithm. Some options to consider: linear < [bi]cubic < nohalo/lohalo

-- Note that we do NOT automatically find & register computed brushes because that's an easy way to execute arbitrary Lua code & cause a security issue unless handled very carefully
