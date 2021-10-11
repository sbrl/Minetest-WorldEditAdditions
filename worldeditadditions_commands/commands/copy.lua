local wea = worldeditadditions
--  ██████  ██████  ██████  ██    ██
-- ██      ██    ██ ██   ██  ██  ██
-- ██      ██    ██ ██████    ████
-- ██      ██    ██ ██         ██
--  ██████  ██████  ██         ██
worldedit.register_command("copy", { -- TODO: Make this an override
	params = "<axis:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> <count> [<axis> <count> [...]]",
	description = "Copies the defined region to another location - potentially on multiple axes at once.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text then params_text = "" end
		
		local parts = wea.split_shell(params_text)
		
		local copy_offset = wea.parse.axes(parts)
		
		if copy_offset == wea.Vector3.new() then 
			return false, "Refusing to copy region a distance of 0 nodes"
		end
		
		return true, copy_offset:floor()
	end,
	nodes_needed = function(name)
		-- We don't actually modify anything, but without returning a
		-- number here safe_region doesn't work
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, copy_offset)
		local start_time = wea.get_ms_time()
		
		local source_pos1 = wea.Vector3.clone(worldedit.pos1[name])
		local source_pos2 = wea.Vector3.clone(worldedit.pos2[name])
		
		local target_pos1 = source_pos1:add(copy_offset)
		local target_pos2 = source_pos2:add(copy_offset)
		
		local success, nodes_modified = wea.copy(
			source_pos1, source_pos2,
			target_pos1, target_pos2
		)
		
		local time_taken = wea.get_ms_time() - start_time
		
		
		minetest.log("action", name.." used //copy from "..source_pos1.." - "..source_pos2.." to "..target_pos1.." - "..target_pos2..", modifying "..nodes_modified.." nodes in "..wea.format.human_time(time_taken))
		return true, nodes_modified.." nodes copied using offset "..copy_offset.." in "..wea.format.human_time(time_taken)
	end
})
