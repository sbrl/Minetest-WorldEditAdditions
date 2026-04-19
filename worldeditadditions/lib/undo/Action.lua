local weac = worldeditadditions_core
local Vector3 = weac.Vector3

--- A single action that was performed and is now recorded to disk.
-- @class worldeditadditions.undo.Action
local Action = {}
Action.__index = Action
Action.__name = "Action" -- hack for wea.inspect

-- TODO this should be a core utils function
local function make_instance(tbl)
	local result = tbl
	if result == nil then
		result = {}
	end
	setmetatable(result, Action)
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

-- worldname/worldeditadditions/Action/<player_name>/<action#>_<action_name>_<before|after>.mts


local function make_action(dirpath_root)
	local inst = make_instance({
		--- The root directory in which the action is stored.
		-- @type string
		dirpath_root = dirpath_root
	})
	
	if not core.path_exists(inst.dirpath_root) then
		core.mkdir(inst.dirpath_root)
	end
	inst.filepath_before = inst.dirpath_root .. weac.dirsep .. "before.mts"
	inst.filepath_after = inst.dirpath_root .. weac.dirsep .. "after.mts"
	inst.filepath_meta = inst.dirpath_root .. weac.dirsep .. "meta.cfg"
	--- The action's metadata.
	-- @type worldeditadditions.io.ConfigFile
	inst.meta = weac.io.ConfigFile.New(inst.filepath_meta)
	
	return inst
end

function Action.Load(dirpath_root)
	local inst = make_action(dirpath_root)
	return inst
end

--- Creates a new action on disk.
-- IMPORTANT: Don't forget to call `Action:attach_before()` and `Action:attach_after()`!
-- @param dirpath_root	string	The root directory that the action should be saved in.
-- @param name			string	The name of the action - i.e. the command executed.
-- @returns	Action		The newly created Action.
function Action.New(dirpath_root, name)
	local inst = make_action(dirpath_root)
	inst.meta:set("name", name)
	inst.meta:save()
	return inst
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

--- Attaches a StagedVoxelRegion that represents the state BEFORE the action takes place to this Action.
-- Saves `before` to disk in the right place.
-- @param	before	StagedVoxelRegion	The StagedVoxelRegion from before the action happened.
-- @returns nil
function Action:attach_before(before)
	before:save(self.dirpath_root .. weac.dirsep .. "before.mts")
	inst.meta:set("pos1_x", tostring(before.pos1.x))
	inst.meta:set("pos1_y", tostring(before.pos1.y))
	inst.meta:set("pos1_z", tostring(before.pos1.z))
	inst.meta:set("pos2_x", tostring(before.pos2.x))
	inst.meta:set("pos2_y", tostring(before.pos2.y))
	inst.meta:set("pos2_z", tostring(before.pos2.z))
	inst.meta:save()
end

--- Attaches a StagedVoxelRegion that represents the state AFTER the action takes place to this Action.
-- Saves `after` to disk in the right place.
-- 
-- Aside: the `Action` API is designed like this so that the `StagedVoxelRegion`s for the before and after stages don't hafta be kept in memory at the same time.
-- @param	after	StagedVoxelRegion	The StagedVoxelRegion from after the action happened.
-- @returns nil
function Action:attach_after(after)
	local pos1 = self:pos1() -- pos1 from `before`
	local pos2 = self:pos2() -- pos1 from `before`
	if pos1 ~= after.pos1 then return false, "Error: before.pos1 does not match after.pos1. Please ensure both before and after affect the same region." end
	if pos2 ~= after.pos2 then return false, "Error: before.pos1 does not match after.pos1. Please ensure both before and after affect the same region." end
	after:save(self.dirpath_root .. weac.dirsep .. "after.mts")
end

--- Fetches and returns pos1 of the region affected by the action.
-- @returns	Vector3	pos1 of the region affected by the action.
function Action:pos1() -- : means self is defined automatically ref https://stackoverflow.com/a/78840956/1460422
	return Vector3.new(
		tonumber(self.meta:get("pos1_x", 0), 10),
		tonumber(self.meta:get("pos1_y", 0), 10),
		tonumber(self.meta:get("pos1_z", 0), 10)
	)
end
--- Fetches and returns pos2 of the region affected by the action.
-- @returns	Vector3	pos2 of the region affected by the action.
function Action:pos2() -- : means self is defined automatically ref https://stackoverflow.com/a/78840956/1460422
	return Vector3.new(
		tonumber(self.meta:get("pos2_x", 0), 10),
		tonumber(self.meta:get("pos2_y", 0), 10),
		tonumber(self.meta:get("pos2_z", 0), 10)
	)
end

--- Gets the name associated with the action - i.e. the command run.
-- @returns	string
function Action:name()
	return self.meta:get("name")
end

--- Returns the id of this action.
-- @returns	number	The integer id of this action.
function Action:id()
	local action_id = worldeditadditions.basename(self.dirpath_root)
	if not action_id then return nil end
	local action_id_number = tonumber(action_id, 10)
	if not action_id_number then return nil end
	return action_id_number
end


return Action
