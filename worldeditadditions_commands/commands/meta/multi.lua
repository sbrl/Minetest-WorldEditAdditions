--- Executes multiple worldedit commands in sequence.
-- @module worldeditadditions.multi

-- explode(separator, string)
-- From http://lua-users.org/wiki/SplitJoin
local function explode(delim, str)
	local ll, is_done
	local delim_length = string.len(delim)
	ll = 0
	is_done = false
	
	return function()
		if is_done then return end
		
		local result
		local loc = string.find(str, delim, ll, true) -- find the next d in the string
		if loc ~= nil then -- if "not not" found then..
			result = string.sub(str, ll, loc - 1) -- Save it in our array.
			ll = loc + delim_length -- save just after where we found it for searching next time.
		else
			result = string.sub(str, ll) -- Save what's left in our array.
			is_done = true
		end
		
		return result
	end
end

minetest.register_chatcommand("/multi", {
	params = "/<command_a> <args> //<command_b> <args> /<command_c> <args>.....",
	description = "Executes multiple chat commands in sequence. Just prepend a list of space-separated chat commands with //multi, and you're good to go! The forward slashes at the beginning of each chat command must be the same as if you were executing it normally.",
	privs = { worldedit = true },
	func = function(name, params_text)
		if not params_text then return false, "Error: No commands specified, so there's nothing to do." end
		params_text = worldeditadditions.trim(params_text)
		if #params_text == 0 then return false, "Error: No commands specified, so there's nothing to do." end
		
		local master_start_time = worldeditadditions.get_ms_time()
		local times = {}
		
		-- Tokenise the input into a list of commands
		local success, commands = worldeditadditions.parse.tokenise_commands(params_text)
		if not success then return success, commands end
		
		for i, command in ipairs(commands) do
			-- print("[DEBUG] i", i, "command: '"..command.."'")
			local start_time = worldeditadditions.get_ms_time()
			
			local found, _, command_name, args = command:find("^([^%s]+)%s(.+)$")
			if not found then command_name = command end
			-- Things start at 1, not 0 in Lua :-(
			command_name = worldeditadditions.trim(command_name):sub(2) -- Strip the leading /
			if not args then args = "" end
			-- print("command_name", command_name)
			
			worldedit.player_notify(name, "#"..i..": "..command)
			
			local cmd = minetest.chatcommands[command_name]
			if not cmd then
				return false, "Error: "..command_name.." isn't a valid command."
			end
			if not minetest.check_player_privs(name, cmd.privs) then
				return false, "Your privileges are insufficient to execute "..command_name..". Abort."
			end
			-- print("[DEBUG] command_name", command_name, "cmd", dump2(cmd))
			minetest.log("action", name.." runs "..command)
			cmd.func(name, args)
			
			times[#times + 1] = (worldeditadditions.get_ms_time() - start_time)
			-- i = i + 1
		end
		
		local total_time = (worldeditadditions.get_ms_time() - master_start_time)
		local done_message = {}
		table.insert(done_message,
			string.format("Executed %d commands in %s (",
				#times,
				worldeditadditions.format.human_time(total_time)
			)
		)
		local message_parts = {}
		for j=1,#times do
			table.insert(message_parts, worldeditadditions.format.human_time(times[j]))
		end
		table.insert(done_message, table.concat(message_parts, ", "))
		table.insert(done_message, ")")
		
		worldedit.player_notify(name, table.concat(done_message, ""))
	end
})
