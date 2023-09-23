

local localpath = wea_c.modpath.."/utils/parse/file/"

--- Parsers specifically for file formats.
-- @namespace worldeditadditions_core.parse.file
return {
	weaschem = dofile(localpath.."weaschem.lua")
}