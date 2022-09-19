local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████  ██████ ███████ ███    ██ ████████ ███████ ██████
-- ██      ██      ██      ████   ██    ██    ██      ██   ██
-- ███████ ██      █████   ██ ██  ██    ██    █████   ██████
--      ██ ██      ██      ██  ██ ██    ██    ██      ██   ██
-- ███████  ██████ ███████ ██   ████    ██    ███████ ██   ██
worldeditadditions_core.register_command("scentre", {
	params = "",
	description = "Set WorldEdit region positions 1 and 2 to the centre of the current selection.",
	privs = {worldedit=true},
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name)
		local mean = Vector3.mean(
			Vector3.clone(worldedit.pos1[name]),
			Vector3.clone(worldedit.pos2[name])
		)
		local pos1, pos2 = Vector3.clone(mean), Vector3.clone(mean)
		
		pos1 = pos1:floor()
		pos2 = pos2:ceil()
		
		worldedit.pos1[name], worldedit.pos2[name] = pos1, pos2
		worldedit.mark_pos1(name)
		worldedit.mark_pos2(name)
		
		return true, "position 1 set to "..pos1..", position 2 set to "..pos2
	end,
})

-- lua print(vecs.mean.x..", "..vecs.mean.y..", "..vecs.mean.z)
