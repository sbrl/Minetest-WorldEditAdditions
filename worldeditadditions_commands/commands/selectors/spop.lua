local wea = worldeditadditions
local weac = worldeditadditions_core


-- ███████ ██████   ██████  ██████
-- ██      ██   ██ ██    ██ ██   ██
-- ███████ ██████  ██    ██ ██████
--      ██ ██      ██    ██ ██
-- ███████ ██       ██████  ██
worldeditadditions_core.register_command("spop", {
	params = "",
	description = "Pops a region off your (per-user) selection stack.",
	privs = { worldedit = true },
	parse = function(params_text)
		return true
	end,
	nodes_needed = function(name)
		return 0
	end,
	func = function(name)
		local success, pos1, pos2 = wea.spop(name)
		if not success then return success, pos1 end
		
		weac.pos.set1(name, pos1)
		weac.pos.set2(name, pos2)
		-- worldedit.pos1[name] = pos1
		-- worldedit.pos2[name] = pos2
		-- worldedit.marker_update(name)
		
		local new_count = wea.scount(name)
		local plural = "s are"
		if new_count == 1 then plural = " is" end
		
		local region_text = pos1.." - "..pos2
		
		minetest.log("action", name .. " used //spopped at "..region_text..". Stack height is now " .. new_count.." regions")
		return true, "Region "..region_text.." popped from selection stack; "..new_count.." region"..plural.." now in the stack"
	end
})
