local weac = worldeditadditions_core


local worldedit_unmark
if minetest.registered_chatcommands["/unmark"] then
	worldedit_unmark = minetest.registered_chatcommands["/unmark"].func
end

local function do_unmark(name, params_text)
	-- Hide the WorldEdit marker, if appropriate
	if type(worldedit_unmark) == "function" then
		worldedit_unmark(name, params_text)
	end

	-- Hide the WorldEditAdditions marker
	weac.pos.unmark(name)
end

if minetest.registered_chatcommands["/unmark"] then
	minetest.override_chatcommand("/unmark", {
		params = "",
		description = "Hide the markers for the defined region (and any other positions), but do not remove the points themselves.",
		func = do_unmark
	})
else
	minetest.register_chatcommand("/unmark", {
		params = "",
		description = "Hide the markers for the defined region (and any other positions), but do not remove the points themselves.",
		privs = { worldedit = true },
		func = do_unmark
	})
end