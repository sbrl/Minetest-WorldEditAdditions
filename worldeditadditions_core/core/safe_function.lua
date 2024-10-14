local weac = worldeditadditions_core
---
-- @module worldeditadditions_core

-- ███████  █████  ███████ ███████         ███████ ███    ██ 
-- ██      ██   ██ ██      ██              ██      ████   ██ 
-- ███████ ███████ █████   █████           █████   ██ ██  ██ 
--      ██ ██   ██ ██      ██              ██      ██  ██ ██ 
-- ███████ ██   ██ ██      ███████ ███████ ██      ██   ████ 


local function send_error(player_name, cmdname, msg, stack_trace)
	print("DEBUG:HAI SEND_ERROR")
	local msg_compiled = table.concat({
		"[//", cmdname, "] Error: ",
		msg,
		"\n",
		"Please report this by opening an issue on GitHub! Bug report link (ctrl + click):\n",
		"https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new?title=",
		weac.format.escape(stack_trace:match("^[^\n]+")), -- extract 1st line & escape
		"&body=",
		weac.format.escape(table.concat({
			[[## Describe the bug
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
- **Command name:** ]],
			cmdname,
			"\n",
			"```\n",
			stack_trace,
			"\n",
			"```\n",
		}, "")),

		"\n",
		"-------------------------------------\n",
		"*** Stack trace ***\n",
		stack_trace,
		"\n",
		"-------------------------------------\n"
	}, "")

	print("DEBUG:player_notify player_name", player_name, "msg_compiled", msg_compiled)
	worldedit.player_notify(player_name, msg_compiled)
end


--- Calls the given function `fn` with the UNPACKED arguments from `args`, catching errors and sending the calling player a nice error message with a report link.
-- 
-- WARNING: Do NOT nest `safe_function()` calls!!!
-- @param	fn			function		The function to call
-- @param	args		table			The table of args to unpack and send to `fn` as arguments
-- @param	string|nil	player_name		The name of the player affected. If nil then no message is sent to the player.
-- @param	string		error_msg		The error message to send when `fn` inevitably crashes.
-- @param	string|nil		cmdname		Optional. The name of the command being run.
-- @returns	bool,any,...	A success bool (true == success), and then if success == true the rest of the arguments are the (unpacked) return values from the function called. If success == false, then the 2nd argument will be the stack trace.
function safe_function(fn, args, player_name, error_msg, cmdname)
	local retvals
	local success_xpcall, stack_trace = xpcall(function()
		retvals = { fn(weac.table.unpack(args)) }
	end, debug.traceback)
	
	if not success_xpcall then
		send_error(player_name, cmdname, error_msg, stack_trace)
		weac:emit("error", {
			fn = fn,
			args = args,
			player_name = player_name,
			cmdname = cmdname,
			stack_trace = stack_trace,
			error_msg = error_msg
		})
		minetest.log("error", "[//"..tostring(cmdname).."] Caught error from running function ", fn, "with args", weac.inspect(args), "for player ", player_name, "with provided error message", error_msg, ". Stack trace: ", stack_trace)
		return false, stack_trace
	end
	
	
	return true, retvals
end


return safe_function
