-- ███████  ██████ ███████ ███    ██ ████████ ███████ ██████
-- ██      ██      ██      ████   ██    ██    ██      ██   ██
-- ███████ ██      █████   ██ ██  ██    ██    █████   ██████
--      ██ ██      ██      ██  ██ ██    ██    ██      ██   ██
-- ███████  ██████ ███████ ██   ████    ██    ███████ ██   ██
local wea = worldeditadditions
worldedit.register_command("scentre", {
	params = "",
	description = "Set WorldEdit region positions 1 and 2 to the centre of the current selection.",
	privs = {worldedit=true},
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name)
		local vecs = {}
		vecs.mean = wea.vector.mean(worldedit.pos1[name],worldedit.pos2[name])
		vecs.p1, vecs.p2 = vector.new(vecs.mean), vector.new(vecs.mean)
		wea.vector.floor(vecs.p1)
		wea.vector.ceil(vecs.p2)
		worldedit.pos1[name], worldedit.pos2[name] = vecs.p1, vecs.p2
		worldedit.mark_pos1(name)
		worldedit.mark_pos2(name)
		return true, "position 1 set to " .. minetest.pos_to_string(vecs.p1) .. ", position 2 set to " .. minetest.pos_to_string(vecs.p2)
	end,
})

-- lua print(vecs.mean.x..", "..vecs.mean.y..", "..vecs.mean.z)
