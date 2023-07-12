local weac = worldeditadditions_core
local Vector3 = weac.Vector3


local function do_set(name, i)
	local player = minetest.get_player_by_name(name)
	weac.pos.set(name, i, Vector3.round(player:get_pos()))
end

local function do_set1(name, params_text)
	do_set(name, 1)
end
local function do_set2(name, params_text)
	do_set(name, 2)
end

if minetest.registered_chatcommands["/pos1"] then
	minetest.override_chatcommand("/pos1", {
		params = "",
		description =
		"Sets pos1 to the current position of the calling player.",
		func = do_set1
	})
else
	minetest.register_chatcommand("/pos1", {
		params = "",
		description =
		"Sets pos1 to the current position of the calling player.",
		privs = { worldedit = true },
		func = do_set1
	})
end
if minetest.registered_chatcommands["/pos2"] then
	minetest.override_chatcommand("/pos2", {
		params = "",
		description = "Sets pos2 to the current position of the calling player.",
		func = do_set2 
	})
else
	minetest.register_chatcommand("/pos2", {
		params = "",
		description = "Sets pos2 to the current position of the calling player.",
		privs = { worldedit = true },
		func = do_set2
	})
end


minetest.register_chatcommand("//pos", {
	params = "<index>",
	description = "Sets position <index> to the current position of the calling player.",
	privs = { worldedit = true },
	func = function(name, params_text)
		local i = tonumber(params_text)
		if type(i) ~= "number" then
			worldedit.player_notify(name, "Error: Invalid index number given.")
			return
		end
		i = math.floor(i)
		
		do_set(name, i)
	end
})