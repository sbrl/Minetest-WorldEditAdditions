local wea = worldeditadditions
local weac = worldeditadditions_core
local Vector3 = weac.Vector3
local Action = wea.undo.Action


--- A stack of actions done by a SINGLE player recorded and saved to disk
-- @class worldeditadditions.undo.ActionsStack
local ActionsStack = {}
ActionsStack.__index = ActionsStack
ActionsStack.__name = "ActionsStack" -- hack for wea.inspect

-- TODO make this use the WorldEditAdditions settings system.... when sad settings system is finished
local max_actions = 100

local function make_instance(tbl)
	local result = tbl
	if result == nil then
		result = {}
	end
	setmetatable(result, ActionsStack)
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

-- worldname/worldeditadditions/ActionsStack/<player_name>/<action#>_<action_name>_<before|after>.mts


local function load_action_stack(self)
	if not core.path_exists(self.dirpath_root) then
		core.mkdir(self.dirpath_root)
	end
	
	local files = core.get_dir_list(self.dirpath_root, true)
	for _, dirname in files do
		local action_id = tonumber(dirname)
		if action_id then
			-- TODO lazy-load here
			self.actions[action_id] = Action.Load(self.dirpath_root..weac.dirsep..dirname)
		end
		-- just in case the actions are not listed in order by `core.get_dir_list()`
		self.action_id_newest = math.max(self.action_id_newest, action_id)
		self.action_id_oldest = math.min(self.action_id_oldest, action_id)
	end
end

function ActionsStack.Load(player)
	local inst = make_instance({
		--- The name of the player this stack belongs to.
		-- @type string
		player = player,
		--- The list of actions recorded.
		-- @type Table<number,Action>
		actions = {},
		--- The integer id of the newest action in the stack.
		-- @type	number
		action_id_newest = 0,
		--- The integer id of the oldest action in the stack.
		-- @type	number
		action_id_oldest = 0,
		--- The root directory in which the actions stack is stored.
		-- @type string
		dirpath_root = weac.datapath .. weac.dirsep .. "ActionsStack" .. weac.dirsep .. player
	})
	load_action_stack(inst)
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

--- Create a new `Action` and add it to the stack.
-- Don't forget to call `Action:attach_before()` and `Action:attach_after`!
function ActionsStack:push(name)
	local action_id = self.action_id_newest + 1
	self.action_id_newest = action_id + 1
	local dirpath_action = self.dirpath_root..weac.dirsep..tostring(action_id)
	local action = Action.New(dirpath_action, name)
	
	-- TODO remove the oldest action in the stack IF we're over `max_actions` here
	
	return action
end

--- Gets the action from the stack associated with the given id.
-- @param	id	number	The integer of the id to return.
-- @returns	Action?		The action associated with the given id, or nil if not present.
function ActionsStack:get(id)
	return self.actions[id]
end

function ActionsStack:empty()
	if self.action_id_newest == self.action_id_oldest and not self:get(self.action_id_newest) then return true end
end

--- Returns the oldest action in the stack.
-- @returns	Action?	The oldest action in the stack, or `nil` if the `ActionsStack` is empty.
function ActionsStack:oldest()
	return self:get(self.action_id_oldest)
end
--- Returns the newest action in the stack.
-- @returns	Action?	The newest action in the stack, or `nil` if the `ActionsStack` is empty.
function ActionsStack:newest()
	return self:get(self.action_id_newest)
end

return ActionsStack
