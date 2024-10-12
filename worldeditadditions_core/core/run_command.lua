--- 
-- @module worldeditadditions_core

-- WARNING: safe_region MUST NOT be imported more than once, as it defines chat commands. If you want to import it again elsewhere, check first that multiple dofile() calls don't execute a file more than once.
local wea_c = worldeditadditions_core
local safe_region = dofile(wea_c.modpath.."/core/safe_region.lua")
local human_size = wea_c.format.human_size

-- TODO: Reimplement worldedit.player_notify(player_name, msg_text)

--- Actually runs the command in question. [HIDDEN]
-- Unfortunately needed to keep the codebase clena because Lua sucks.
-- @internal
-- @param	player_name	string		The name of the player executing the function. 
-- @param	func		function	The function to execute.
-- @param	parse_result	table	The output of the parsing function that was presumably called earlier. Will be unpacked and passed to `func` as arguments.
-- @param	tbl_event	table		Internal event table used when calling `worldeditadditions_core.emit(event_name, tbl_event)`.
-- @returns	nil
local function run_command_stage2(player_name, func, parse_result, tbl_event)
	wea_c:emit("pre-execute", tbl_event)
	local success, result_message = func(player_name, wea_c.table.unpack(parse_result))
	print("DEBUG:run_command_stage2 SUCCESS", success, "RESULT_MESSAGE", result_message)
	if not success then
		
		result_message = "[//"..tostring(tbl_event.cmdname).."] "..result_message
	end
	
	if result_message then
		-- TODO: If we were unsuccessful, then colour the message red
		worldedit.player_notify(player_name, result_message)
	end
	tbl_event.success = success
	tbl_event.result = result_message
	wea_c:emit("post-execute", tbl_event)
end

local function send_error(player_name, cmdname, msg, stack_trace)
	print("DEBUG:HAI SEND_ERROR")
	local msg_compiled = table.concat({
		"[//", cmdname, "] Error: ",
		msg,
		"\n",
		"Please report this by opening an issue on GitHub! Bug report link:\n",
		"https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new?title=",
		wea_c.format.escape(stack_trace:match("^[^\n]+")), -- extract 1st line & escape
		"&body=",
		wea_c.format.escape([[## Describe the bug
What's the bug? Be clear and detailed but concise in our explanation. Don't forget to include any context, error messages, logs, and screenshots required to understand the issue if applicable.

## Reproduction steps
Steps to reproduce the behaviour:
1. Go to '...'
2. Click on '....'
3. Enter this command to '....'
4. See error

## System information (please complete the following information)
- **Operating system and version:** [e.g. iOS]
- **Minetest version:** [e.g. 5.8.0]
- **WorldEdit version:**
- **WorldEditAdditions version:**

Please add any other additional specific system information here too if you think it would help.

## Stack trace
- Command name: ]]),
		wea_c.format.escape(cmdname),
		wea_c.format.escape("```\n"),
		wea_c.format.escape(stack_trace),
		wea_c.format.escape("\n```"),
		"-------------------------------------\n",
		"*** Stack trace ***\n",
		stack_trace,
		"\n",
		"-------------------------------------"
	}, "")
	
	print("DEBUG:player_notify player_name", player_name, "msg_compiled", msg_compiled)
	worldedit.player_notify(player_name, msg_compiled)
end

--- Command execution pipeline: before `paramtext` parsing but after validation.
-- 
-- See `worldeditadditions_core.run_command`
-- @event	pre-parse
-- @format	{ player_name: string, cmddef: table, paramtext: string }

--- Command execution pipeline: directly after `paramtext` parsing
--
-- See `worldeditadditions_core.run_command`
-- @event	post-parse
-- @format	{ player_name: string, cmddef: table, paramtext: string, paramargs: table }

--- Command execution pipeline: after the `nodesneeded` function is called (if provided).
--
-- See `worldeditadditions_core.run_command`
-- @event	post-nodesneeded
-- @format	{ player_name: string, cmddef: table, paramtext: string, paramargs: table, potential_changes: number }

--- Command execution pipeline: directly before the command is invoked.
--
-- See `worldeditadditions_core.run_command`
-- @event	pre-execute
-- @format	{ player_name: string, cmddef: table, paramtext: string, paramargs: table, potential_changes: number }

--- Command execution pipeline: after the command is executed.
--
-- See `worldeditadditions_core.run_command`
-- @event	post-execute
-- @format	{ player_name: string, cmddef: table, paramtext: string, paramargs: table, potential_changes: number, success: boolean, result: any }


--- Runs a command with the given name and options for the given player.
-- Emits several events in the process, in the following order:
-- 1. **`pre-parse`:** Before `paramtext` parsing but after validation.
-- 2. **`post-parse`:** Directly after `paramtext` parsing
-- 3. **`post-nodesneeded`:** If a `nodesneeded` function is provided, this executes after the nodesneeded function is called.
-- 4. **`pre-execute`:** Directly before the command is invoked.
-- 5. **`post-execute`:** After the command is executed.
-- 
-- Items #4 and #5 here are actually emitted by the private internal function `run_command_stage2`.
-- 
-- The event object passed has the following properties:
-- - `cmddef` (table): The WEA-registered definition of the command
-- - `cmdname` (string): The name of the command, sans-forward slashes
-- - `paramtext` (string): The unparsed `paramtext` the user passed as argument(s) to the command.
-- - `player_name` (string): The name of the player calling the command.
-- - `paramargs` (table): The parsed arguments returned by the parsing function. Available in `post-parse` and later.
-- - `potential_changes` (number): The number of potential nodes that could be changed as a result of running the command. `post-nodesneeded` and later: remember not all commands have an associated `nodesneeded` function.
-- - `success` (boolean): Whether the command executed successfully or not. Available only in `post-execute`.
-- - `result` (any): The `result` value returned by the command function. Value depends on the command executed. Available only in `post-execute`.
-- @param	cmdname		string	The name of the command to run.
-- @param	options		table	The table of options associated with the command. See worldeditadditions_core.register_command for more information.
-- @param	player_name	string	The name of the player to execute the command for.
-- @param	paramtext	string	The unparsed argument string to pass to the command when executing it.
local function run_command(cmdname, options, player_name, paramtext)
	if options.require_pos > 0 and not worldedit.pos1[player_name] and not wea_c.pos.get1(player_name) then
		worldedit.player_notify(player_name, "Error: pos1 must be selected to use this command.")
		return false
	end
	if options.require_pos > 1 and not worldedit.pos2[player_name] and not wea_c.pos.get2(player_name) then
		worldedit.player_notify(player_name, "Error: Both pos1 and pos2 must be selected (together making a region) to use this command.")
		return false
	end
	local pos_count = wea_c.pos.count(player_name)
	if options.require_pos > 2 and pos_count < options.require_pos then
		worldedit.player_notify(player_name, "Error: At least "..options.require_pos.."positions must be defined to use this command, but you only have "..pos_count.." defined (try using the multiwand).")
		return false
	end
	
	local tbl_event = {
		cmddef = options,
		cmdname = cmdname,
		paramtext = paramtext,
		player_name = player_name
	}
	
	wea_c:emit("pre-parse", tbl_event)
	
	local parse_result, error_message
	local did_error = false
	xpcall(function()
		parse_result = { options.parse(paramtext)}
	end, function(error_raw)
		did_error = true
		error_message = error_raw
		print("DEBUG:parse_result>>error", error_raw, "stack trace", debug.traceback())
	end)
	if did_error then
		print("DEBUG:parse_result EXIT_DUE_TO_ERROR")
		send_error(player_name, cmdname, "The command crashed when parsing the arguments.", error_message)
		print("DEBUG:parse_result EXIT_DUE_TO_ERROR __final_call__")
		return false
	end -- handling is wrapped with xpcall()
	
	local success = table.remove(parse_result, 1)
	if not success then
		worldedit.player_notify(player_name, ("[//"..tostring(cmdname).."] "..tostring(parse_result[1])) or "Invalid usage (no further error message was provided by the command. This is probably a bug.)")
		return false
	end
	
	tbl_event.paramargs = parse_result
	wea_c:emit("post-parse", tbl_event)
	
	
	if options.nodes_needed then
		local potential_changes = options.nodes_needed(player_name, wea_c.table.unpack(parse_result))
		
		tbl_event.potential_changes = potential_changes
		wea_c:emit("post-nodesneeded", tbl_event)
		
		if type(potential_changes) ~= "number" then
			worldedit.player_notify(player_name, "Error: The command '"..cmdname.."' returned a "..type(potential_changes).." instead of a number when asked how many nodes might be changed. Abort. This is a bug.")
			return
		end
		
		local limit = wea_c.safe_region_limit_default
		if wea_c.safe_region_limits[player_name] then
			limit = wea_c.safe_region_limits[player_name]
		end
		if type(potential_changes) == "string" then
			worldedit.player_notify(player_name, "/"..cmdname.." "..paramtext.." "..potential_changes..". Type //y to continue, or //n to cancel (in this specific situation, your configured limit via the //saferegion command does not apply).")
		elseif potential_changes > limit then
			worldedit.player_notify(player_name, "/"..cmdname.." "..paramtext.." may affect up to "..human_size(potential_changes).." nodes. Type //y to continue, or //n to cancel (see the //saferegion command to control when this message appears).")
			safe_region(player_name, cmdname, function()
				run_command_stage2(player_name, options.func, parse_result, tbl_event)
			end)
		else
			run_command_stage2(player_name, options.func, parse_result, tbl_event)	
		end
	else
		run_command_stage2(player_name, options.func, parse_result, tbl_event)
	end
	
end

return run_command
