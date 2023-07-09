
-- ███████  █████  ███████ ███████     ██████  ███████  ██████  ██  ██████  ███    ██
-- ██      ██   ██ ██      ██          ██   ██ ██      ██       ██ ██    ██ ████   ██
-- ███████ ███████ █████   █████       ██████  █████   ██   ███ ██ ██    ██ ██ ██  ██
--      ██ ██   ██ ██      ██          ██   ██ ██      ██    ██ ██ ██    ██ ██  ██ ██
-- ███████ ██   ██ ██      ███████     ██   ██ ███████  ██████  ██  ██████  ██   ████

local worldedit_command_y, worldedit_command_n

if minetest.global_exists("worldedit") then
	worldedit_command_y = minetest.registered_chatcommands["/y"].func
	worldedit_command_n = minetest.registered_chatcommands["/n"].func
end

--- A table that holds at most 1 pending function call per player.
-- @value	table<string,function>
-- @internal
local pending_calls = {}

--- Captures the given function in the safe_region subsystem for later execution.
-- @param	player_name		string		The name of the player.
-- @param	cmdname			string		The name of the command being executed.
-- @param	func			function	The function to execute later. Will be passed NO ARGUMENTS should it ever get executed in the future (this is not guaranteed).
-- @returns	nil
local function safe_region(player_name, cmdname, func)
	pending_calls[player_name] = {
		cmdname = cmdname,
		func = func
	}
end

minetest.override_chatcommand("/y", {
	params = "",
	description = "Run a pending operation that was captured by the safe region system earlier.",
	func = function(player_name)
		if pending_calls[player_name] == nil then
			if minetest.global_exists("worldedit") and worldedit_command_y ~= nil then
				worldedit_command_y(player_name)
			else
				worldedit.player_notify(player_name, "There aren't any pending operations at the moment.")
			end
		else
			pending_calls[player_name].func()
			pending_calls[player_name] = nil
		end
	end
})

minetest.override_chatcommand("/n", {
	params = "",
	description = "Abort a pending operation that was captured by the safe region system.",
	func = function(player_name)
		if pending_calls[player_name] == nil then
			if minetest.global_exists("worldedit") and worldedit_command_y ~= nil then
				worldedit_command_n(player_name)
			else
				worldedit.player_notify(player_name, "There aren't any operations pending, so there's nothing to abort.")
			end
		else
			worldedit.player_notify(player_name, "Aborting captured command /"..pending_calls[player_name].cmdname..".")
			pending_calls[player_name] = nil
		end
	end
})


return safe_region
