
local wea_c = worldeditadditions_core

local function register_alias(cmdname_target, cmdname_source, override)
	if override == nil then override = false end
	
	local def_source = wea_c.fetch_command_def(cmdname_source)
	
	if not def_source then
		minetest.log("error", "worldeditadditions_core: Failed to register alias for "..cmdname_source.." → "..cmdname_target..", as the source command doesn't exist.")
		return false
	end
	
	if wea_c.fetch_command_def(cmdname_target) and not override then
		minetest.log("error", "worldeditadditions_core: Failed to register alias for "..cmdname_source.." → "..cmdname_target..", as the target command exists and override wasn't set to true.")
		return false
	end
	
	-- print("DEBUG ALIAS source "..cmdname_source.." target "..cmdname_target)
	
	if minetest.registered_chatcommands["/" .. cmdname_target] then
		minetest.override_chatcommand(
			"/"..cmdname_target,
			minetest.registered_chatcommands["/" .. cmdname_source]
		)
	else
		minetest.register_chatcommand(
			"/"..cmdname_target,
			minetest.registered_chatcommands["/" .. cmdname_source]
		)
	end
	wea_c.registered_commands[cmdname_target] = wea_c.registered_commands[cmdname_source]
	
	if minetest.global_exists("worldedit") then
		worldedit.registered_commands[cmdname_target] = worldedit.registered_commands[cmdname_source]
	end
end


return register_alias
