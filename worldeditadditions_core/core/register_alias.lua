
local wea_c = worldeditadditions_core
---
-- @module worldeditadditions_core


--- Register an alias of an existing worldeditadditions/worldedit command.
-- @param	cmdname_target	string	The target name for the alias
-- @param	cmdname_source	string	The source name of the command to alias the target to.
-- @param	override=false	bool	Whether to override the target command name if it exists. Defaults to false, which results in an error being thrown if the target command name already exists.
-- @returns	bool			Whether the override operation was successful or not.
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
	
	return true
end


return register_alias
