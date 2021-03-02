-- ███████ ██████  ██    ██ ███████ ██   ██
-- ██      ██   ██ ██    ██ ██      ██   ██
-- ███████ ██████  ██    ██ ███████ ███████
--      ██ ██      ██    ██      ██ ██   ██
-- ███████ ██       ██████  ███████ ██   ██
worldedit.register_command("spush", {
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
		local success, msg = worldeditadditions.spush(name, worldedit.pos1[name], worldedit.pos2[name])
		if not success then
			return success, msg
		end
		
		local new_count = worldeditadditions.scount(name)
		local plural = "s are"
		if new_count == 1 then plural = " is" end
		
		local region_text = worldeditadditions.vector.tostring(worldedit.pos1[name]).." - "..worldeditadditions.vector.tostring(worldedit.pos2[name])
		
		minetest.log("action", name .. " used //spush at "..region_text..". Stack height is now " .. new_count.." regions")
		return true, "Region "..region_text.." pushed onto selection stack; "..new_count.." region"..plural.." now in the stack"
	end
})
