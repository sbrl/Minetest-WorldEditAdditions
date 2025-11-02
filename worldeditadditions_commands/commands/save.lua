local weac = worldeditadditions_core

-- ███████   █████   ██    ██  ███████
-- ██       ██   ██  ██    ██  ██     
-- ███████  ███████  ██    ██  █████  
--      ██  ██   ██   ██  ██   ██     
-- ███████  ██   ██    ████    ███████
worldeditadditions_core.register_command("save", {
	params = "<filename>",
	description =
	"EXPERIMENTAL. Saves the currently defined region to disk.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			return false, "Error: no filename specified."
		end
		
		local filename = weac.trim(params_text):gsub("[/\\]+", "")
		
		return success, filename
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, filename)
		local start_time = wea_c.get_ms_time()
		
		local 
		
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])

		local changes = worldeditadditions.layers(
			pos1, pos2,
			node_list,
			min_slope, max_slope
		)
		local time_taken = wea_c.get_ms_time() - start_time

		-- print("DEBUG min_slope", min_slope, "max_slope", max_slope)
		-- print("DEBUG min_slope", math.deg(min_slope), "max_slope", math.deg(max_slope))

		minetest.log("action",
			name ..
			" used //layers at " ..
			pos1 ..
			" - " ..
			pos2 ..
			", replacing " ..
			changes.replaced ..
			" nodes and skipping " ..
			changes.skipped_columns ..
			" columns (" ..
			changes.skipped_columns_slope .. " due to slope constraints) in " .. wea_c.format.human_time(time_taken))
		return true,
			changes.replaced ..
			" nodes replaced and " ..
			changes.skipped_columns ..
			" columns skipped (" ..
			changes.skipped_columns_slope .. " due to slope constraints) in " .. wea_c.format.human_time(time_taken)
	end
})
