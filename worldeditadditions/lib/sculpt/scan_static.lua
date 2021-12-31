local wea = worldeditadditions
local Vector3 = wea.Vector3

local import_static = dofile(wea.modpath.."/lib/sculpt/import_static.lua")

local function import_filepath(filepath, name, overwrite_existing)
	if overwrite_existing and wea.sculpt.brushes[name] ~= nil then
		return false, "Error: A brush with the name '"..name.."' already exists."
	end
	
	local success, brush, brush_size = import_static(filepath)
	if not success then return success, "Error while reading from '"..filepath.."': "..brush end
	
	wea.sculpt.brushes[name] = {
		brush = brush,
		size = brush_size
	}
	
	return true
end

--- Scans the given directory and imports all static brushes found.
-- Static brushes have the file extension ".brush.tsv" (without quotes).
-- @param	dirpath	string		The path to directory that contains the static brushs to import.
-- @returns	bool,loaded,errors	A success boolean, followed by the number of brushes loaded, followed by the number of errors encountered while loading brushes (errors are logged as warnings with Minetest)
return function(dirpath, overwrite_existing)
	if overwrite_existing == nil then overwrite_existing = false end
	local files = wea.io.scandir_files(dirpath)
	
	local brushes_loaded = 0
	local errors = 0
	
	
	for i, filename in pairs(files) do
		if wea.str_ends(filename, ".brush.tsv") then
			local filepath = dirpath.."/"..filename
			local name = filename:gsub(".brush.tsv", "")
			
			local success, msg = import_filepath(filepath, name, overwrite_existing)
			if not success then
				minetest.log("warning", "[WorldEditAdditions:sculpt] Encountered error when loading brush from '"..filepath.."':"..msg)
			end
			brushes_loaded = brushes_loaded + 1
		end
	end
	
	return true, brushes_loaded, errors
end
