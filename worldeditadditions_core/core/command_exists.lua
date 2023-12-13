--- WorldEditAdditions chat command registration
-- @namespace worldeditadditions_core
local wea_c = worldeditadditions_core


--- Returns whether a WorldEditAdditions (or WorldEdit) command exists with the given name.
-- Note that this does NOT check for general Minetest chat commands - only commands registered through WorldEditAdditions or WorldEdit, if WorldEdit is currently loaded - the eventual plan is to make it an optional dependency.
-- @param	cmdname		string	The name of the command to check for. Remember to remove the first forward slash! In other words if you would normally type `//layers` in-game, then you'd call `worldeditadditions.command_exists("/layers")`.
-- @param	only_wea	bool	If true, then only check for WorldEditAdditions commands and not commands from related compatible mods such as WorldEdit.
-- @returns	bool		Whether a WorldEdit/WorldEditAdditions command exists with the given name.
local function command_exists(cmdname, only_wea)
	if only_wea == nil then only_wea = false end
	if wea_c.registered_commands[cmdname] ~= nil then
		return true
	end
	if only_wea == true then return false end
	if worldedit.registered_commands[cmdname] ~= nil then
		return true
	end
	return false
end

return command_exists