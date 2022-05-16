local wea_c = worldeditadditions_core


for name,definition in pairs(worldedit.registered_commands) do
	-- This check should not be needed since worldeditadditions_commands
	-- depends on this mod (so it will overwrite any worldedit definitions,
	-- since worldedit is loaded first), but it's here just in case
	if not wea_c.registered_commands[name] then
		-- The Minetest chat command should already be imported here, so we
		-- just need to import worldedit chat command definition here
		wea_c.registered_commands[name] = definition
	else
		minetest.log("info", "Skipping registration of worldedit command "..name..", as it's already a registered worldeditadditions command")
	end
end
