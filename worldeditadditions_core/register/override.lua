local we_c = worldeditadditions_core
function we_c.override_command(name, def)
	local def = table.copy(def)
	local success, err = we_c.check_command(name, def)
	
	if not success then
		error(err)
		return false
	end

	minetest.override_chatcommand("/" .. name, {
		privs = def.privs,
		params = def.params,
		description = def.description,
		func = function(player_name, param)
			return we_c.chatcommand_handler(name, player_name, param)
		end,
	})
	worldedit.registered_commands[name] = def
end

function we_c.alias_override(alias, original)
	if not worldedit.registered_commands[original] then
		minetest.log("error", "worldedit_shortcommands: original " .. original .. " does not exist")
		return
	end
	if minetest.chatcommands["/" .. alias] then
		minetest.override_chatcommand("/" .. alias, minetest.chatcommands["/" .. original])
		worldedit.registered_commands[alias] = worldedit.registered_commands[original]
	else
		minetest.register_chatcommand("/" .. alias, minetest.chatcommands["/" .. original])
		worldedit.registered_commands[alias] = worldedit.registered_commands[original]
	end

end
