
--- File formats WorldEditAdditions supports reading and/or writing.
-- It is currently unclear which of these formats we will actually implement.
-- 
-- Current Status:
-- 
-- Format	| Read	| Write
-- ---------|-------|-------
-- weaschem	| 		| 
-- mtschem	| 		| 
-- we		| 		| 
-- 
-- @namespace worldeditadditions_core.io.FileFormats


return {
	--- The WorldEditAdditions Schematic file format.
	-- This format also has the ability to store deltas (aka the differences between a previous state and the current state)
	WorldEditAdditions = "weaschem",
	
	--- The optimised Minetest Schematic file format.
	-- File extensions: .mtschem
	MinetestSchematic = "mtschem",
	
	--- The WorldEdit format.
	-- This format takes up a lot of disk space. The use of this format is not recommended.
	-- 
	-- File extensions: .we
	WorldEdit = "we"
}