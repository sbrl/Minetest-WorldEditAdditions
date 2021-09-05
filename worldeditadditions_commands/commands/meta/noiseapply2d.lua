-- ███    ██  ██████  ██ ███████ ███████  █████  ██████  ██████  ██   ██    ██ ██████  ██████
-- ████   ██ ██    ██ ██ ██      ██      ██   ██ ██   ██ ██   ██ ██    ██  ██       ██ ██   ██
-- ██ ██  ██ ██    ██ ██ ███████ █████   ███████ ██████  ██████  ██     ████    █████  ██   ██
-- ██  ██ ██ ██    ██ ██      ██ ██      ██   ██ ██      ██      ██      ██    ██      ██   ██
-- ██   ████  ██████  ██ ███████ ███████ ██   ██ ██      ██      ███████ ██    ███████ ██████


worldedit.register_command("noiseapply2d", {
	params = "<threshold> <scale> <command_name> <args>",
	description = "Executes the given command (automatically prepending '//'), but uses a 2d noise function with both a threshold value (a number between 0 and 1) and a scale value (number, 1 = normal scale, for small areas 10+ is recommended) to filter where in the defined region it's applied.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if params_text == "" then return false, "Error: No command specified." end
		
		local threshold_text, scale_text, cmd_name, args_text = params_text:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)%s*(.*)")
		if not args_text then
			args_text = ""
		end
		
		-- Note that we search the worldedit commands here, not the minetest ones
		local cmd_we = worldedit.registered_commands[cmd_name]
		if cmd_we == nil then
			return false, "Error: "..cmd_name.." isn't a valid command."
		end
		if cmd_we.require_pos ~= 2 and cmd_name ~= "multi" then
			return false, "Error: The command "..cmd_name.." exists, but doesn't take 2 positions and so can't be used with //noiseapply2d."
		end
		
		-- Run parsing of target command
		-- Lifted from cubeapply in WorldEdit
		local args_parsed = {cmd_we.parse(args_text)}
		if not table.remove(args_parsed, 1) then
			return false, args_parsed[1]
		end
		
		local threshold = tonumber(threshold_text)
		if not threshold then
			return false, "Error: Invalid threshold value '"..threshold_text.."'. Threshold values should be a floating-point number between 0 and 1."
		end
		if threshold < 0 or threshold > 1 then
			return false, "Error: The threshold value '"..threshold.."' is out of bounds. Threshold values should be floating-point numbers between 0 and 1."
		end
		local scale = tonumber(scale_text)
		if not scale then
			return false, "Error: Invalid scale value '"..threshold_text.."'. Threshold values should be a floating-point number between 0 and 1."
		end
		
		return true, 1 - threshold, scale, cmd_we, args_parsed
	end,
	nodes_needed = function(name)
		return worldedit.volume(
			worldedit.pos1[name],
			worldedit.pos2[name]
		)
	end,
	func = function(name, threshold, scale, cmd, args_parsed)
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to execute the command '"..cmd.."'."
		end
		
		local pos1, pos2 = worldeditadditions.Vector3.sort(
			worldedit.pos1[name],
			worldedit.pos2[name]
		)
		
		
		local success, stats_time = worldeditadditions.noiseapply2d(
			pos1, pos2,
			threshold,
			worldeditadditions.Vector3.new(
				scale, scale, scale
			),
			function()
				cmd.func(name, worldeditadditions.table.unpack(args_parsed))
			end
		)
		if not success then return success, stats_time end
		
		local time_overhead = 100 - worldeditadditions.round((stats_time.fn / stats_time.all) * 100, 3)
		local text_time_all = worldeditadditions.format.human_time(stats_time.all)
		local text_time_fn = worldeditadditions.format.human_time(stats_time.fn)
		
		minetest.log("action", name.." used //noiseapply2d at "..pos1.." - "..pos2.." in "..text_time_all)
		return true, "Complete in "..text_time_all.." ("..text_time_fn.." fn, "..time_overhead.."% noiseapply2d overhead)"
	end
})
