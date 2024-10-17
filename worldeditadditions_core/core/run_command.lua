--- 
-- @module worldeditadditions_core

-- WARNING: safe_region MUST NOT be imported more than once, as it defines chat commands. If you want to import it again elsewhere, check first that multiple dofile() calls don't execute a file more than once.
local weac = worldeditadditions_core
local safe_region = dofile(weac.modpath.."/core/safe_region.lua")
local human_size = weac.format.human_size
local safe_function = weac.safe_function

--- Handles the success bool and result message string that a command's main `func` returns.
-- @param success	bool	Whether the command executed successfully or not.
-- @param result_message	string	The message (as a string) to send to the player.
local function handle_success_resultmsg(player_name, cmdname, success, result_message)
	if success then
		if not result_message then
			result_message = "//" .. tostring(cmdname) .. " successful"
		end
		weac.notify.ok(player_name, result_message)
	else
		if not result_message then
			result_message =
			"An unspecified (likely user) error was returned by the command. It is a bug that a specific error message is not returned here. It is not necessarily a bug that an error was thrown: your command invocation could have contained invalid syntax, for example."
		end
		weac.notify.error(player_name, "[//" .. tostring(cmdname) .. "] " .. result_message)
	end
	
	return success, result_message
end

--- Actually runs the command in question. [HIDDEN]
-- Unfortunately needed to keep the codebase clena because Lua sucks.
-- @internal
-- @param	player_name	string		The name of the player executing the function. 
-- @param	func		function	The function to execute.
-- @param	parse_result	table	The output of the parsing function that was presumably called earlier. Will be unpacked and passed to `func` as arguments.
-- @param	tbl_event	table		Internal event table used when calling `worldeditadditions_core.emit(event_name, tbl_event)`.
-- @returns	nil
local function run_command_stage2(player_name, func, parse_result, tbl_event)
	weac:emit("pre-execute", tbl_event)
	
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	local args = {}
	-- If we're async, add the callback function as the 1st argument before everything else
	if tbl_event.cmddef.async then
		table.insert(args, function(success, result_message)
			success, result_message = handle_success_resultmsg(player_name, tbl_event.cmdname, success, result_message)
			
			tbl_event.success = success
			tbl_event.result = result_message
			weac:emit("post-execute", tbl_event)
		end)
	end
	-- Add player_name, unpack(args_from_parse_func).... afterwards 
	table.insert(args, player_name)
	for _,value in ipairs(parse_result) do
		table.insert(args, value)
	end
	
	-- Run the cmd itself and catch errors
	local success_safefn, retvals = safe_function(func, args, player_name, "The function crashed during execution.", tbl_event.cmdname)
	if not success_safefn then return false end
	
	-- BELOW: We handle the IMMEDIATE RETURN VALUE. For async commands this requires special handling as the actual exit of async commands is above.
	
	-- If a function is async (pass `async = true` in the table passed to weac.register_command()`), then if there are no return values then we assume it was successful.
	if #retvals ~= 2 and not tbl_event.cmddef.async then
		weac.notify.error(player_name, "[//"..tostring(tbl_event.cmdname).."] This command is not async and the main execution function for it returned "..tostring(#retvals).." arguments instead of the expected 2 (success, message), so it is unclear whether it succeeded or not. This is a bug!")
	end
	 
	if #retvals == 2 then
		local success, result_message = retvals[1], retvals[2]
		success, result_message = handle_success_resultmsg(player_name, tbl_event.cmdname, success, result_message)
		
		tbl_event.success = success
		tbl_event.result = result_message
		
	end
	
	-- This is outside the above before we need to fire post-execute even if `#retvals ~= 2` or something else happened
	-- 
	-- Don't fire the post-execute event if async = true unless we were explicitly told its fine. If async = false then just go right ahead anyway
	if not tbl_event.cmddef.async or (tbl_event.cmddef.async and success) then
		weac:emit("post-execute", tbl_event)
	end
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
-- - `result` (any): The `result` value returned by the command function. Value depends on the command executed. Available only in `post-execute`. SHOULD be a string but don't count on it.
-- 
-- @param	cmdname		string	The name of the command to run.
-- @param	options		table	The table of options associated with the command. See worldeditadditions_core.register_command for more information.
-- @param	player_name	string	The name of the player to execute the command for.
-- @param	paramtext	string	The unparsed argument string to pass to the command when executing it.
local function run_command(cmdname, options, player_name, paramtext)
	if options.require_pos > 0 and not worldedit.pos1[player_name] and not weac.pos.get1(player_name) then
		weac.notify.error(player_name, "Error: pos1 must be selected to use this command.")
		return false
	end
	if options.require_pos > 1 and not worldedit.pos2[player_name] and not weac.pos.get2(player_name) then
		weac.notify.error(player_name, "Error: Both pos1 and pos2 must be selected (together making a region) to use this command.")
		return false
	end
	local pos_count = weac.pos.count(player_name)
	if options.require_pos > 2 and pos_count < options.require_pos then
		weac.notify.error(player_name, "Error: At least "..options.require_pos.."positions must be defined to use this command, but you only have "..pos_count.." defined (try using the multiwand).")
		return false
	end
	
	local tbl_event = {
		cmddef = options,
		cmdname = cmdname,
		paramtext = paramtext,
		player_name = player_name
	}
	
	weac:emit("pre-parse", tbl_event)
	
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	-- local did_error = false
	local success_safefn, parse_result = safe_function(options.parse, { paramtext }, player_name, "The command crashed when parsing the arguments.", cmdname)
	if not success_safefn then return false end -- error already sent to the player above
	
	if #parse_result == 0 then 
		weac.notify.error(player_name, "[//"..tostring(cmdname).."] No return values at all were returned by the parsing function - not even a success boolean. This is a bug - please report it :D")
		return false
	end
	
	local success = table.remove(parse_result, 1)
	if not success then
		weac.notify.error(player_name, "[//"..tostring(cmdname).."] "..(tostring(parse_result[1]) or "Invalid usage (no further error message was provided by the command. This is probably a bug.)"))
		return false
	end
	
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
	tbl_event.paramargs = parse_result
	weac:emit("post-parse", tbl_event)
	
	
	if options.nodes_needed then
		local success_xpcall_nn, retvals_nn = safe_function(options.nodes_needed, { player_name, weac.table.unpack(parse_result) }, player_name, "The nodes_needed function crashed!", cmdname)
		if not success_xpcall_nn then return false end
		
		if #retvals_nn == 0 then
			weac.notify.error(player_name, "[//"..tostring(cmdname).."] Error: The nodes_needed function didn't return any values. This is a bug!")
			return false
		end
		local potential_changes = retvals_nn[1]
		
		tbl_event.potential_changes = potential_changes
		weac:emit("post-nodesneeded", tbl_event)
		
		if type(potential_changes) ~= "number" then
			weac.notify.error(player_name, "Error: The command '"..cmdname.."' returned a "..type(potential_changes).." instead of a number when asked how many nodes might be changed. Abort. This is a bug.")
			return
		end
		
		local limit = weac.safe_region_limit_default
		if weac.safe_region_limits[player_name] then
			limit = weac.safe_region_limits[player_name]
		end
		if type(potential_changes) == "string" then
			weac.notify.warn(player_name, "/"..cmdname.." "..paramtext.." "..potential_changes..". Type //y to continue, or //n to cancel (in this specific situation, your configured limit via the //saferegion command does not apply).")
		elseif potential_changes > limit then
			weac.notify.warn(player_name, "/"..cmdname.." "..paramtext.." may affect up to "..human_size(potential_changes).." nodes. Type //y to continue, or //n to cancel (see the //saferegion command to control when this message appears).")
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
