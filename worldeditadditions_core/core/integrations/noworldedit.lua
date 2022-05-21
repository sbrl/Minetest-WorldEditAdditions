local wea_c = worldeditadditions_core

--- WorldEdit shim just in case WorldEdit doesn't exist.
-- Eventually this will go away.
worldedit = {
	-- Note that you want worldeditadditions_core.registered_commands, and not worldedit.registered_commands! This table is not guaranteed to contain all command definitions in the future, whereas worldedit command definitions are guaranteed to be imported into this worldeditadditions_core.registered_commands.
	registered_commands = {  }
}
