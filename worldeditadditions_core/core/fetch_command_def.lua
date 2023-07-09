

--- Fetches the definition of a WorldEditAdditions or WorldEdit command
-- Does not support fetching generic Minetest commands - check
-- minetest.registered_chatcommands for this.
-- @param	cmdname		string		The name of the command to fetch the definition for.
local function fetch_command_def(cmdname)
	local wea_c = worldeditadditions_core
	
	if wea_c.registered_commands[cmdname] then
		return wea_c.registered_commands[cmdname]
	end
	if minetest.global_exists("worldedit") and worldedit.registered_commands and worldedit.registered_commands[cmdname] then
		return worldedit.registered_commands[cmdname]
	end
	
	return nil
end

return fetch_command_def
