local weac = worldeditadditions_core


local function do_mark(name, params_text)
	-- TODO: Decide whether we need to hided the worldeditadditions marker here or not.
	-- Show the WorldEditAdditions marker
	weac.pos.mark(name)
end

if minetest.registered_chatcommands["/mark"] then
	minetest.override_chatcommand("/mark", {
		params = "",
		description = "Show the markers for the defined region (and any other positions) once more.",
		func = do_mark
	})
else
	minetest.register_chatcommand("/mark", {
		params = "",
		description = "Show the markers for the defined region (and any other positions) once more.",
		privs = { worldedit = true },
		func = do_mark
	})
end