local wea_c = worldeditadditions_core

-- ███████  ██████  ██████
-- ██      ██    ██ ██   ██
-- █████   ██    ██ ██████
-- ██      ██    ██ ██   ██
-- ██       ██████  ██   ██
-- Process:
-- 1: Split `params_text` into two vars with unpack(wea.split(params_text,"%sdo%s"))
-- 2: Further split the two vars into two tables, one of values and the other of {command, args} sub tables
-- 3: For each entry in the values table execute each {command, args} sub table using gsub to replace "%%" in the args with the current value

-- Specs:
-- Command cluster support using ()
-- ?Basename support for values
-- ?Comma deliniation support for values

local function step(params, __callback)
	-- Initialize additional params on first call
	if not params.first then
		params.i = 1 -- Iteration number
		params.time = 0 -- Total execution time
		params.first = true
	end
	
	-- Load current value to use
	local v = params.values[params.i]
	
	-- Start a timer
	local start_time = wea_c.get_ms_time()
	-- Execute command
	params.cmd.func(params.player_name, params.args:gsub("%%+",v))
	-- Finish timer and add to total
	params.time = params.time + wea_c.get_ms_time() - start_time
	-- Increment iteration state
	params.i = params.i + 1
	
	if params.i <= #params.values then
		-- If we haven't run out of values call function again
		minetest.after(0, step, params, __callback)
	else
		__callback(true, "//for completed mapping values ["..table.concat(params.values, ", ").."] over /"..params.cmd_name.." "..tostring(params.args).." in "..wea_c.format.human_time(params.time))
	end
end

worldeditadditions_core.register_command("for", {
	params = "<value1> <value2> <value3>... do //<command> <arg> %% <arg>",
	description = "Executes a chat command for each value before \" do \" replacing any instances of \"%%\" with those values. The forward slashes at the beginning of the chat command must be the same as if you were executing it normally.",
	privs = { worldedit = true },
	async = true,
	parse = function(params_text)
		if not params_text:match("%sdo%s") then
			return false, "Error: \"do\" argument is not present."
		end
		local parts = wea_c.split(params_text,"%sdo%s")
		if parts[1] == "" then
			return false, "Error: No values specified."
		end
		if not parts[2] then
			return false, "Error: No command specified."
		end
		local values = wea_c.split(parts[1],"%s")
		local command, args = parts[2]:match("/([^%s]+)%s*(.*)$")
		if not args then args = ""
		else args = wea_c.trim(args) end
		
		return true, values, command, args
	end,
	func = function(__callback, name, values, command, args)
		print("DEBUG://for __callback", wea_c.inspect(__callback), "name", name)
		
		local cmd = minetest.registered_chatcommands[command]
		if not cmd then
			return false, "Error: "..command.." isn't a valid command."
		end
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to run /\""..command.."\"."
		end
		
		
		step({
			player_name = name,
			cmd_name = command,
			values = values,
			cmd = cmd,
			args = args
		}, __callback)
		
		-- Returning nothing + async = true means we're going async and we'll get back to `run_command` later. Until then, I'm going to have to put you on hold :P
		-- * cue hold music *
		-- ref https://youtu.be/3to4vaWl2dY
	end
})
