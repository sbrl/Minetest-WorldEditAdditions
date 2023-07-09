-- Executes multiple worldedit commands in sequence.
-- **Warning:** If a command is asynchronous (i.e. it doesn't finish when the function registered in the chat command returns), the next command will be executed before the previous one is finished! The solution to this is an implementation of Promise<any> and then ensuring that all functions registered are thenable as in JS, but this has not been implemented yet.
local wea_c = worldeditadditions_core

minetest.register_chatcommand("/multi", {
	params = "/<command_a> <args> //<command_b> <args> /<command_c> <args>.....",
	description = "Executes multiple chat commands in sequence. Just prepend a list of space-separated chat commands with //multi, and you're good to go! The forward slashes at the beginning of each chat command must be the same as if you were executing it normally.",
	privs = { worldedit = true },
	func = function(name, params_text)
		if not params_text then return false, "Error: No commands specified, so there's nothing to do." end
		params_text = wea_c.trim(params_text)
		if #params_text == 0 then return false, "Error: No commands specified, so there's nothing to do." end
		
		local master_start_time = wea_c.get_ms_time()
		local times = {}
		
		-- Tokenise the input into a list of commands
		local success, commands = wea_c.parse.tokenise_commands(params_text)
		if not success then return success, commands end
		if type(commands) ~= "table" then return success, commands end
		
		for i, command in ipairs(commands) do
			local start_time = wea_c.get_ms_time()
			
			local found, _, command_name, args = command:find("^([^%s]+)%s(.+)$")
			if not found then command_name = command end
			-- Things start at 1, not 0 in Lua :-(
			command_name = wea_c.trim(command_name):sub(2) -- Strip the leading /
			if not args then args = "" end
			-- print("command_name", command_name)
			
			worldedit.player_notify(name, "#"..i..": "..command)
			
			local cmd = minetest.registered_chatcommands[command_name]
			if not cmd then
				return false, "Error: "..command_name.." isn't a valid command."
			end
			if not minetest.check_player_privs(name, cmd.privs) then
				return false, "Your privileges are insufficient to execute "..command_name..". Abort."
			end
			-- print("[DEBUG] command_name", command_name, "cmd", dump2(cmd))
			minetest.log("action", name.." runs "..command)
			cmd.func(name, args)
			
			times[#times + 1] = (wea_c.get_ms_time() - start_time)
			-- i = i + 1
		end
		
		local total_time = (wea_c.get_ms_time() - master_start_time)
		local done_message = {}
		table.insert(done_message,
			string.format("Executed %d commands in %s (",
				#times,
				wea_c.format.human_time(total_time)
			)
		)
		local message_parts = {}
		for j=1,#times do
			table.insert(message_parts, wea_c.format.human_time(times[j]))
		end
		table.insert(done_message, table.concat(message_parts, ", "))
		table.insert(done_message, ")")
		
		worldedit.player_notify(name, table.concat(done_message, ""))
	end
})
