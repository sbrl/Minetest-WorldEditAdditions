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

local wea = worldeditadditions
worldedit.register_command("for", {
	params = "<value1> <value2> <value3>... do //<command> <arg> %% <arg>",
	description = "Executes a chat command for each value before \" do \" replacing any instances of \"%%\" with those values. The forward slashes at the beginning of the chat command must be the same as if you were executing it normally.",
	privs = { worldedit = true },
	parse = function(params_text)
		if not params_text:match("%sdo%s") then
			return false, "Error: \"do\" argument is not present."
		end
		local parts = wea.split(params_text,"%sdo%s")
		if not parts[1] == "" then
			return false, "Error: No values specified."
		end
		if not parts[2] then
			return false, "Error: No command specified."
		end
		local values = wea.split(parts[1],"%s")
		local command, args = parts[2]:match("/([^%s]+)%s*(.*)$")
		if not args then args = ""
		else args = wea.trim(args) end
		
		return true, values, command, args
	end,
	func = function(name, values, command, args)
		local cmd = minetest.chatcommands[command]
		if not cmd then
			return false, "Error: "..command.." isn't a valid command."
		end
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to run \""..command.."\"."
		end
		-- Start a timer
		local start_time = wea.get_ms_time()
		for _,v in pairs(values) do
			cmd.func(name, args:gsub("%%+",v))
		end
		-- Finish timer
		local time_taken = wea.get_ms_time() - start_time
		
		return true, "For "..table.concat(values,", ")..", command completed in " .. wea.format.human_time(time_taken)
	end
})
