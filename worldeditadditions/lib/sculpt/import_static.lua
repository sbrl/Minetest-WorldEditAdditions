local wea = worldeditadditions
local Vector3 = wea.Vector3

local parse_static = dofile(wea.modpath.."/lib/sculpt/parse_static.lua")

--- Reads and parses the brush stored in the specified file.
-- @param	filepath	string		The path to file that contains the static brush to read in.
-- @returns	true,table,Vector3|false,string		A success boolean, followed either by an error message as a string or the brush (as a table) and it's size (as an X/Y Vector3)
return function(filepath)
	local handle = io.open(filepath)
	if not handle then
		handle:close()
		return false, "Error: Failed to open the static brush file at '"..filepath.."'."
	end
	
	local data = handle:read("*all")
	handle:close()
	
	local success, brush, brush_size = parse_static(data)
	if not success then return success, brush end
	
	return true, brush, brush_size
end
