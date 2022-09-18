local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██████  ██    ██ ███████ ██   ██
-- ██      ██   ██ ██    ██ ██      ██   ██
-- ███████ ██████  ██    ██ ███████ ███████
--      ██ ██      ██    ██      ██ ██   ██
-- ███████ ██       ██████  ███████ ██   ██
worldeditadditions_core.register_command("spush", {
	params = "",
	description = "Pushes the currently defined region onto your (per-user) selection stack.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		return true
	end,
	nodes_needed = function(name)
		return 0
	end,
	func = function(name)
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local pos2 = Vector3.clone(worldedit.pos2[name])
		local success, msg = wea.spush(name, pos1, pos2)
		if not success then
			return success, msg
		end
		
		local new_count = wea.scount(name)
		local plural = "s are"
		if new_count == 1 then plural = " is" end
		
		local region_text = pos1.." - "..pos2
		
		minetest.log("action", name .. " used //spush at "..region_text..". Stack height is now " .. new_count.." regions")
		return true, "Region "..region_text.." pushed onto selection stack; "..new_count.." region"..plural.." now in the stack"
	end
})
