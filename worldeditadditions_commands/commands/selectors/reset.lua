local weac = worldeditadditions_core


local worldedit_reset
if minetest.registered_chatcommands["/reset"] then
	worldedit_reset = minetest.registered_chatcommands["/reset"].func
end

local function do_reset(name, params_text)
	-- Hide the WorldEdit marker, if appropriate
	if type(worldedit_reset) == "function" then
		worldedit_reset(name, params_text)
	end

	-- Hide the WorldEditAdditions marker
	weac.pos.clear(name)
end

if minetest.registered_chatcommands["/reset"] then
	minetest.override_chatcommand("/reset", {
		params = "",
		description = "Clears all defined points and the currently defined region.",
		func = do_reset
	})
else
	minetest.register_chatcommand("/reset", {
		params = "",
		description = "Clears all defined points and the currently defined region.",
		privs = { worldedit = true },
		func = do_reset
	})
end