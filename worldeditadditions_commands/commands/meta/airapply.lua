--  █████  ██ ██████   █████  ██████  ██████  ██   ██    ██
-- ██   ██ ██ ██   ██ ██   ██ ██   ██ ██   ██ ██    ██  ██
-- ███████ ██ ██████  ███████ ██████  ██████  ██     ████
-- ██   ██ ██ ██   ██ ██   ██ ██      ██      ██      ██
-- ██   ██ ██ ██   ██ ██   ██ ██      ██      ███████ ██


worldedit.register_command("airapply", {
	params = "<command_name> <args>",
	description = "Executes the given command (automatically prepending '//'), but only on non-air nodes within the defined region.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if params_text == "" then return false, "Error: No command specified." end
		
		local cmd_name, args_text = params_text:match("([^%s]+)%s+(.+)")
		if not cmd_name then
			cmd_name = params_text
			args_text = ""
		end
		
		-- Note that we search the worldedit commands here, not the minetest ones
		local cmd_we = worldedit.registered_commands[cmd_name]
		if cmd_we == nil then
			return false, "Error: "..cmd_name.." isn't a valid command."
		end
		if cmd_we.require_pos ~= 2 and cmd_name ~= "multi" then
			return false, "Error: The command "..cmd_name.." exists, but doesn't take 2 positions and so can't be used with //airapply."
		end
		
		-- Run parsing of target command
		-- Lifted from cubeapply in WorldEdit
		local args_parsed = {cmd_we.parse(args_text)}
		if not table.remove(args_parsed, 1) then
			return false, args_parsed[1]
		end
		
		return true, cmd_we, args_parsed
	end,
	nodes_needed = function(name)
		return worldedit.volume(
			worldedit.pos1[name],
			worldedit.pos2[name]
		)
	end,
	func = function(name, cmd, args_parsed)
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to execute the command '"..cmd.."'."
		end
		
		local pos1, pos2 = worldeditadditions.Vector3.sort(
			worldedit.pos1[name],
			worldedit.pos2[name]
		)
		
		
		local success, stats_time = worldeditadditions.airapply(
			pos1, pos2,
			function()
				cmd.func(name, worldeditadditions.table.unpack(args_parsed))
			end
		)
		if not success then return success, stats_time end
		
		
		local time_overhead = 100 - worldeditadditions.round((stats_time.fn / stats_time.all) * 100, 3)
		local text_time_all = worldeditadditions.format.human_time(stats_time.all)
		local text_time_fn = worldeditadditions.format.human_time(stats_time.fn)
		
		minetest.log("action", name.." used //airapply at "..pos1.." - "..pos2.." in "..text_time_all)
		return true, "Complete in "..text_time_all.." ("..text_time_fn.." fn, "..time_overhead.."% airapply overhead)"
	end
})
