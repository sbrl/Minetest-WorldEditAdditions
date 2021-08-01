-- ███████ ██      ██      ██ ██████  ███████ ███████  █████  ██████  ██████  ██   ██    ██
-- ██      ██      ██      ██ ██   ██ ██      ██      ██   ██ ██   ██ ██   ██ ██    ██  ██
-- █████   ██      ██      ██ ██████  ███████ █████   ███████ ██████  ██████  ██     ████
-- ██      ██      ██      ██ ██           ██ ██      ██   ██ ██      ██      ██      ██
-- ███████ ███████ ███████ ██ ██      ███████ ███████ ██   ██ ██      ██      ███████ ██

worldedit.register_command("ellipsoidapply", {
	params = "<command_name> <args>",
	description = "Executes the given command (automatically prepending '//'), clipping the result with an ellipse given by the defined region.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if params_text == "" then return false, "Error: No command specified." end
		
		local cmd_name, args_text = params_text:match("([^%s]+)%s+(.+)")
		if not cmd_name then
			cmd_name = params_text
			args_text = ""
		end
		
		-- print("cmd_name", cmd_name, "args_text", args_text)
		
		-- Note that we search the worldedit commands here, not the minetest ones
		local cmd_we = worldedit.registered_commands[cmd_name]
		if cmd_we == nil then
			return false, "Error: "..cmd_name.." isn't a valid command."
		end
		-- print("cmd require_pos", cmd_we.require_pos, "END")
		if cmd_we.require_pos ~= 2 and cmd_name ~= "multi" then
			return false, "Error: The command "..cmd_name.." exists, but doesn't take 2 positions and so can't be used with //ellipsoidapply."
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
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		return math.ceil(4/3 * math.pi * (pos2.x - pos1.x)/2 * (pos2.y - pos1.y)/2 * (pos2.z - pos1.z)/2)
	end,
	func = function(name, cmd, args_parsed)
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to execute the command '"..cmd.."'."
		end
		
		local success, stats_time = worldeditadditions.ellipsoidapply(
			worldedit.pos1[name], worldedit.pos2[name],
			function()
				cmd.func(name, worldeditadditions.table.unpack(args_parsed))
			end, args_parsed
		)
		local time_overhead = 100 - worldeditadditions.round((stats_time.fn / stats_time.all) * 100, 3)
		
		minetest.log("action", name.." used //ellipsoidapply at "..worldeditadditions.vector.tostring(worldedit.pos1[name]).." - "..worldeditadditions.vector.tostring(worldedit.pos2[name]).." in "..worldeditadditions.format.human_time(stats_time.all))
		return true, "Complete in "..worldeditadditions.format.human_time(stats_time.all).." ("..worldeditadditions.format.human_time(stats_time.fn).." fn, "..time_overhead.."% ellipsoidapply overhead)"
	end
})
