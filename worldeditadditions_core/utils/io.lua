
--- Functions to abstract file I/O away.
-- I'm very suspicious of Minetest's API changing from under our feet.
-- @namespace worldeditadditions_core.io
local io = {
	-- Ref https://minetest.gitlab.io/minetest/minetest-namespace-reference/#utilities
	scandir = function(dirpath)
		return minetest.get_dir_list(dirpath, nil)
	end,
	scandir_files = function(dirpath)
		return minetest.get_dir_list(dirpath, false)
	end,
	scandir_dirs = function(dirpath)
		return minetest.get_dir_list(dirpath, true)
	end,
}

return io
