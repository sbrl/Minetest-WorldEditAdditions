local we_c = worldeditadditions_core
function we_c.register_command(name, def)
	local success, def = we_c.check(name, def)

	if not success then
		return false, def
	end

	minetest.register_chatcommand("/" .. name, {
		privs = def.privs,
		params = def.params,
		description = def.description,
		func = function(player_name, param)
			return we_c.chatcommand_handler(name, player_name, param)
		end,
	})
	worldedit.registered_commands[name] = def
end
