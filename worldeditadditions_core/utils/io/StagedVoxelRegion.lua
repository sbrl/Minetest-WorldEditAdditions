--- A region of the world that is to be or has been saved to/from disk.
-- This class exists to make moving things to/from disk easier and less complicated.
-- 
-- In short, use StagedVoxelRegion.NewFromVoxelManip or StagedVoxelRegion.NewFromTable to SAVE data, and StagedVoxelRegion.Load or StagedVoxelRegion.LoadIntoVoxelManip to LOAD data.
-- @class worldeditadditions_core.io.StagedVoxelRegion

local StagedVoxelRegion = {}
StagedVoxelRegion.__index = StagedVoxelRegion
StagedVoxelRegion.__name = "StagedVoxelRegion" -- A hack to allow identification in wea.inspect





------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- ███████ ████████  █████  ████████ ██  ██████
-- ██         ██    ██   ██    ██    ██ ██     
-- ███████    ██    ███████    ██    ██ ██     
--      ██    ██    ██   ██    ██    ██ ██     
-- ███████    ██    ██   ██    ██    ██  ██████
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--- Creates a new StagedVoxelRegion from the data in a VoxelManipulator.
-- To save data, you probably want to call the save() method.
-- @param	voxelmanip	VoxelManipulator	The voxel manipulator to take data from and save to disk.
-- @param	pos1		Vector3				The position in WORLD SPACE of pos1 of the defined region to stage for saving.
-- @param	pos2		Vector3				The position in WORLD SPACE of pos2 of the defined region to stage for saving.
-- @returns	bool,StagedVoxelRegion	A success boolean, followed by the new StagedVoxelRegion instance.
function StagedVoxelRegion.NewFromVoxelManip(voxelmanip, pos1, pos2)
	
end

--- Creates a new StagedVoxelRegion from the given VoxelManipulator data.
-- To save data, you probably want to call the save() method.
-- @param	area	VoxelArea	The VoxelArea associated with the data.
-- @param	data	number[]	A table of numbers representing the node ids.
-- @param	param2	number[]	A table of numbers representing the param2 data. Should exactly match the data number[] in size.
-- @param	pos1		Vector3				The position in WORLD SPACE of pos1 of the defined region to stage for saving.
-- @param	pos2		Vector3				The position in WORLD SPACE of pos2 of the defined region to stage for saving.
-- @returns	bool,StagedVoxelRegion	A success boolean, followed by the new StagedVoxelRegion instance.
function StagedVoxelRegion.NewFromTable(area, data, param2, pos1, pos2)
	
end

--- Creates a new StagedVoxelRegion from raw data/param2 tables.
-- @param	data	number[]	A table of numbers representing the node ids. Must be ALREADY TRIMMED, NOT just taken straight from a VoxelManip!
-- @param	param2	number[]	A table of numbers representing the param2 data. Should exactly match the data number[] in size. Must be ALREADY TRIMMED, NOT just taken straight from a VoxelManip!
-- @static
-- @param	pos1		Vector3				The position in WORLD SPACE of pos1 of the defined region to stage for saving.
-- @param	pos2		Vector3				The position in WORLD SPACE of pos2 of the defined region to stage for saving.
-- @returns	bool,StagedVoxelRegion	A success boolean, followed by the new StagedVoxelRegion instance.
function StagedVoxelRegion.NewFromRaw(data, param2, pos1, pos2)
	
end

--- Loads voxel data from disk, returning padded arrays suitable for use with VoxelManipulator instances.
--
-- **Note:** This function DOES NOT call finish on the VoxelManipulator!
-- @static
-- @param	voxelmanip	VoxelManipulator	The VoxelManipulator to load the data into.
-- @param	filepath		string	The filepath to load data from.
-- @param	pos1			Vector3	Position 1 in WORLD space to load the data into.
-- @param	pos2			Vector3	Position 2 in WORLD space to load the data into.
-- @param	format="auto"	string	The format that the source data is in. Default: automatic, determine from file extension. See worldeditadditions_core.io.FileFormats for more information.
-- @returns	bool,table	A success/failure bool, followed by TODO: The format of this table is still to be decided.
function StagedVoxelRegion.LoadIntoVoxelManip(filepath, voxelmanip, pos1, pos2, format)
	
end

--- Loads voxel data from disk, returning padded arrays suitable for use with VoxelManipulator instances.
--
-- **Note:** This function does NOT modify the world.
-- @static
-- @param	filepath		string		The filepath to load data from.
-- @param	voxelarea		VoxelArea	The VoxelArea from the target VoxelManipulator instance.
-- @param	pos1			Vector3		Position 1 in WORLD space to load the data into.
-- @param	pos2			Vector3		Position 2 in WORLD space to load the data into.
-- @param	format="auto"	string		The format that the source data is in. Default: automatic, determine from file extension. See worldeditadditions_core.io.FileFormats for more information.
-- @returns	bool,table	A success/failure bool, followed by TODO: The format of this table is still to be decided.
function StagedVoxelRegion.Load(filepath, voxelarea, pos1, pos2, format)
	
end

--- Loads voxel data from disk, returning the raw UNPADDED arrays.
-- In other words, the tables returned by this function WILL NOT fit directly into a VoxelManipulator, because VoxelManipulator data/param2 tables also contain padding data (likely because VoxelManip load only chunks at a time).
-- 
-- **Note:** This function does NOT modify the world.
-- @static
-- @param	filepath		string	The filepath to load data from.
-- @param	pos1			Vector3	Position 1 in WORLD space to load the data into.
-- @param	pos2			Vector3	Position 2 in WORLD space to load the data into.
-- @param	format="auto"	string	The format that the source data is in. Default: automatic, determine from file extension. See worldeditadditions_core.io.FileFormats for more information.
-- @returns	bool,table		A success/failure bool, followed by TODO: The format of this table is still to be decided.
function StagedVoxelRegion.LoadRaw(filepath, pos1, pos2, format)

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
-- @param	filepath		string	The filepath to save the StagedVoxelRegion to.
-- @param	format="auto"	string	The format to save in. Default: automatic, determine from file extension. See worldeditadditions_core.io.FileFormats for more information.
-- @returns	bool			Whether the operation was successful or not.
function StagedVoxelRegion.save(filepath, format)
	
end



return StagedVoxelRegion