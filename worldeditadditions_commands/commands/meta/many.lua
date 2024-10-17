-- Executes multiple worldedit commands in sequence.

local wea_c = worldeditadditions_core


local function step(params)
	local start_time = wea_c.get_ms_time()
	
	local full_cmd = params.cmd_name.." "..params.args
	wea_c.notify.info(params.name, string.format("[ many | /%s ] %d / %d (~%.2f%%) complete | last: %s, average: %s, ETA: ~%s",
		full_cmd,
		(params.i + 1), params.count,
		((params.i + 1) / params.count)*100,
		wea_c.format.human_time(params.times[#params.times] or 0),
		wea_c.format.human_time(wea_c.average(params.times)),
		wea_c.format.human_time(wea_c.eta(
			params.times,
			params.i,
			params.count
		))
	))
	
	local cmd = minetest.registered_chatcommands[params.cmd_name]
	
	minetest.log("action", params.name.." runs "..full_cmd.." (time "..tostring(params.i).." of "..tostring(params.count)..")")
	cmd.func(params.name, params.args)
	
	
	table.insert(params.times, wea_c.get_ms_time() - start_time)
	
	params.i = params.i + 1
	if params.i < params.count then
		minetest.after(0, step, params)
	else
		local total_time = (wea_c.get_ms_time() - params.master_start_time)
		local done_message = {}
		table.insert(done_message,
			string.format("Executed '"..full_cmd.."' %d times in %s (~%s / time)",
				#params.times,
				wea_c.format.human_time(total_time),
				wea_c.format.human_time(
					wea_c.average(params.times)
				)
			)
		)
		-- Don't drown the player if the command was executed many times
		if #params.times < 10 then
			local message_parts = {}
			for j=1,#params.times do
				table.insert(message_parts, wea_c.format.human_time(params.times[j]))
			end
			table.insert(done_message, "; ")
			table.insert(done_message, table.concat(message_parts, ", "))
		end
		table.insert(done_message, ")")
		wea_c.notify.ok(params.name, table.concat(done_message, ""))
	end
end

minetest.register_chatcommand("/many", {
	params = "<times> /<command_a> <args>",
	description = "Executes a single chat command multiple times. The number of times to repeat the command should be specified first. The command to execute follows, and the forward slashes at the beginning thereof must be the same as if you were executing it normally. Note that this command yields with minetest.after to allow other things to happen at the same time.",
	privs = { worldedit = true },
	func = function(name, params_text)
		
		local i = 1 -- For feedback only
		local master_start_time = wea_c.get_ms_time()
		local times = {}
		
		local count, cmd_name, args = params_text:match("^(%d+)%s([^%s]+)%s(.+)$")
		if not count then
			count, cmd_name = params_text:match("^(%d+)%s([^%s]+)$")
			if not count then return false, "Error: Invalid syntax" end
		end
		if not args then args = "" end
		args = wea_c.trim(args)
		-- print("[many] count", count, "cmd_name", cmd_name, "args", args)
		
		count = tonumber(count)
		cmd_name = wea_c.trim(cmd_name):sub(2) -- Things start at 1, not 0 in Lua :-(
		
		-- Check the command we're going to execute
		local cmd = minetest.registered_chatcommands[cmd_name]
		if not cmd then
			return false, "Error: "..cmd_name.." isn't a valid command."
		end
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to run that command."
		end
		
		step({
			master_start_time = master_start_time,
			count = count,
			i = 0,
			times = {},
			cmd_name = cmd_name,
			args = args,
			name = name
		})
	end
})
