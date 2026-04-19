local weac = worldeditadditions_core
local Vector3 = weac.Vector3

--- A region of the world that is to be or has been saved to/from disk.
-- This class exists to make moving things to/from disk easier and less complicated.
-- 
-- In short, use StagedVoxelRegion.NewFromVoxelManip or StagedVoxelRegion.New to SAVE data, and StagedVoxelRegion.Load or StagedVoxelRegion.LoadIntoVoxelManip to LOAD data.
-- @class worldeditadditions_core.io.StagedVoxelRegion

local StagedVoxelRegion = {}
StagedVoxelRegion.__index = StagedVoxelRegion
StagedVoxelRegion.__name = "StagedVoxelRegion" -- A hack to allow identification in wea.inspect


local function make_instance(tbl)
	local result = tbl
	if result == nil then
		result = {}
	end
	setmetatable(result, StagedVoxelRegion)
	return result
end


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- ███████ ████████  █████  ████████ ██  ██████
-- ██         ██    ██   ██    ██    ██ ██     
-- ███████    ██    ███████    ██    ██ ██     
--      ██    ██    ██   ██    ██    ██ ██     
-- ███████    ██    ██   ██    ██    ██  ██████
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--- Creates a new StagedVoxelRegion from the world, using data from the defined pos1..pos2 region.
-- Data is snapshotted using a VoxelManipulator, so no further changes from the world will be present in any data saved to disk once a StagedVOxelRegion instance has been created!
-- @param	pos1	Vector3		pos1 of the defined region
-- @param	pos2	Vector3		pos2 of the defined region
-- @param	offset	Vector3?	Optional offset to apply WHEN LOADING BACK IN AGAIN ONLY. ONLY SAVED IN .weaschem FILES!
function StagedVoxelRegion.New(pos1, pos2, offset)
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	return StagedVoxelRegion.NewFromVoxelManIp(pos1, pos2, offset, manip, area)
end

--- Creates a new StagedVoxelRegion from the given VoxelManipulator data.
-- To save data, you probably want to call the save() method.
-- @param	pos1	Vector3			The position in WORLD SPACE of pos1 of the defined region to stage for saving.
-- @param	pos2	Vector3			The position in WORLD SPACE of pos2 of the defined region to stage for saving.
-- @param	offset	Vector3?		An offset to apply to the loaded StagedVoxelRegion. MAY NOT BE SAVED, but should be applied when applying a StagedVoxelRegion to the world, IF you specify it yourself...
-- @param	manip	VoxelManipulator	The voxelmanip to pull data from 
-- @param	area	VoxelArea			The VoxelArea associated with the data.
-- @returns	bool,StagedVoxelRegion		A success boolean, followed by the new StagedVoxelRegion instance.
function StagedVoxelRegion.NewFromVoxelManIp(pos1, pos2, offset, manip, area)
	if not offset then offset = Vector3.new() end
	return make_instance({
		name = "untitled", -- may not get saved
		description = "", -- may not get saved
		pos1 = pos1:clone(),
		pos2 = pos2:clone(),
		offset = offset, -- TODO this may not get saved
		manip = manip,
		area = area
	})
end

--- Loads voxel data from disk into a StagedVoxelRegion.
-- **Note:** This function does NOT modify the world!
-- See also `StagedVoxelRegion:manip`, `StagedVoxelRegion:area`. to grab a VoxelManipulator
-- @static
-- @param	filepath		string		The filepath to load data from.
-- @param	pos1			Vector3		Position 1 in WORLD space to load the data into.
-- @param	pos2			Vector3		Position 2 in WORLD space to load the data into.
-- @returns	bool,table	A success/failure bool, followed by TODO: The format of this table is still to be decided.
function StagedVoxelRegion.Load(filepath, pos1, pos2)
	-- TODO loading logic here
end

--- Convenience method to load a schematic and return a VoxelManipulator, VoxelArea pair.
-- @param	filepath		string		The filepath to load data from.
-- @param	pos1			Vector3		Position 1 in WORLD space to load the data into.
-- @param	pos2			Vector3		Position 2 in WORLD space to load the data into.
-- @returns	VoxelManipulator,VoxelArea
function StagedVoxelRegion.LoadIntoVoxelManip(filepath, pos1, pos2)
	local svr = StagedVoxelRegion.Load(filepath, pos1, pos2)
	-- NOTE: this does error, but this is unfinished so it's fine
	return svr.manip, svr.area
end


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- ██████  ██    ██ ███    ██  █████  ███    ███ ██  ██████ 
-- ██   ██  ██  ██  ████   ██ ██   ██ ████  ████ ██ ██      
-- ██   ██   ████   ██ ██  ██ ███████ ██ ████ ██ ██ ██      
-- ██   ██    ██    ██  ██ ██ ██   ██ ██  ██  ██ ██ ██      
-- ██████     ██    ██   ████ ██   ██ ██      ██ ██  ██████ 
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--- Saves the StagedVoxelRegion to the filepath.
-- The file format used depends on the file extension:
-- - `.mts`: Minetest Schematic (internally uses [`core.create_schematic()` and `core.place_schematic_on_vmanip()`](https://api.luanti.org/core-namespace-reference/#schematics)) **default**
-- 
-- Future schematic formats being considered:
-- - `.we`: Uberi's (Minetest) WorldEdit schematic format (very bloated!)
-- - `.litematic`: Minecraft Litematica Schematic <https://github.com/maruohon/litematica/issues/53#issuecomment-520279558>
-- - `.schematic`: Minecraft NBT schematic format <https://minecraft.wiki/w/Schematic_file_format>
-- - `.bp`: Minecraft Axiom blueprint (no docs found, please send link!)
-- 
-- @param	filepath		string	The filepath to save the StagedVoxelRegion to.
-- @param	format="auto"	string	The format to save in. Default: automatic, determine from file extension. See worldeditadditions_core.io.FileFormats for more information. Currently, only .mts (Minetest Schematic) is supported.
-- @returns	bool			Whether the operation was successful or not.
function StagedVoxelRegion:save(filepath)
	local ext = string.match(filepath, "%.([a-zA-Z]+)$")
	if not ext then return false, "Error: Filepath '"..tostring(filepath).."' does not contain a file extension" end
	ext = string.lower(ext)
	
	if ext == "mts" then
		local success, msg = weac.io.backends.mts.save(filepath, self.pos1, self.pos2)
		return success, msg
		-- TODO link to backends for other file formats
	else
		return false, "Error: unrecognised file extension "..tostring(ext)..". possible file formats: .mts"
	end
end

return StagedVoxelRegion