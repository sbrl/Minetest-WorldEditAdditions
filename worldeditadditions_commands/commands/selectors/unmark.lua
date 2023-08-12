local weac = worldeditadditions_core


local worldedit_unmark
if minetest.registered_chatcommands["/unmark"] then
	worldedit_unmark = minetest.registered_chatcommands["/unmark"].func
end

local function do_unmark_all()
	local items_removed = 0
	for id, obj in pairs(minetest.object_refs) do
		if obj.get_luaentity then
			local luaentity = obj:get_luaentity()
			if luaentity and (luaentity.name == "worldeditadditions:marker_wall" or luaentity.name == "worldeditadditions:position") then
				obj:remove()
				items_removed = items_removed + 1
			end
		end
	end
	return items_removed
end

local function do_unmark(name, params_text)
	-- Hide the WorldEdit marker, if appropriate
	if type(worldedit_unmark) == "function" then
		worldedit_unmark(name, params_text)
	end
	
	if params_text == "all" then
		local removed = do_unmark_all()
		worldedit.player_notify(name, "Hidden "..removed.." marker entities")
	else
		-- Hide the WorldEditAdditions marker
		weac.pos.unmark(name)
	end
end

if minetest.registered_chatcommands["/unmark"] then
	minetest.override_chatcommand("/unmark", {
		params = "[all]",
		description = "Hide the markers for the defined region (and any other positions), but do not remove the points themselves. If the optional argument keyword 'all' is supplied, then all loaded markers are hidden, regardless of player ownership.",
		func = do_unmark
	})
else
	minetest.register_chatcommand("/unmark", {
		params = "[all]",
		description = "Hide the markers for the defined region (and any other positions), but do not remove the points themselves. If the optional argument keyword 'all' is supplied, then all loaded markers are hidden, regardless of player ownership.",
		privs = { worldedit = true },
		func = do_unmark
	})
end