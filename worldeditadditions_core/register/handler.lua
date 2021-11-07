function worldeditadditions_core.chatcommand_handler(cmd_name, name, param)
	local def = assert(worldedit.registered_commands[cmd_name], "Error: Failed to locate worldedit command definition for command '"..name.."' (this is probably a bug).")

	if def.require_pos == 2 then
		local pos1, pos2 = worldedit.pos1[name], worldedit.pos2[name]
		if pos1 == nil or pos2 == nil then
			worldedit.player_notify(name, "no region selected")
			return
		end
	elseif def.require_pos == 1 then
		local pos1 = worldedit.pos1[name]
		if pos1 == nil then
			worldedit.player_notify(name, "no position 1 selected")
			return
		end
	end

	local parsed = {def.parse(param)}
	local success = table.remove(parsed, 1)
	if not success then
		worldedit.player_notify(name, parsed[1] or "invalid usage")
		return
	end

	if def.nodes_needed then
		local count = def.nodes_needed(name, unpack(parsed))
		safe_region(name, count, function()
			local success, msg = def.func(name, unpack(parsed))
			if msg then
				minetest.chat_send_player(name, msg)
			end
		end)
	else
		-- no "safe region" check
		local success, msg = def.func(name, unpack(parsed))
		if msg then
			minetest.chat_send_player(name, msg)
		end
	end
end
