local weac = worldeditadditions_core
local Vector3 = weac.Vector3

-- ███████   █████   ██    ██  ███████
-- ██       ██   ██  ██    ██  ██     
-- ███████  ███████  ██    ██  █████  
--      ██  ██   ██   ██  ██   ██     
-- ███████  ██   ██    ████    ███████
worldeditadditions_core.register_command("save+", {
	params = "<filename>",
	description =
	"EXPERIMENTAL - DO NOT USE! Saves the currently defined region to disk.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			return false, "Error: no filename specified."
		end
		
		local filename = weac.trim(params_text):gsub("[/\\]+", "")
		
		-- TODO implement offset controls here. Perhaps we do the MC WorldEdit thing here and do it relative to the player's current position? or perhaps also have a custom thing here so it optionally pulls from e.g. pos3 - and then we yeet that to disk so saving/loading trees is easier?
		
		return true, filename
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, filename)
		local start_time = weac.get_ms_time()
		
		local filepath = weac.data_dir .. weac.dirsep .. filename
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		
		-- TODO implement save here
		
		local success, msg = worldeditadditions.save(pos1, pos2, nil, filepath)
		print("DEBUG:cmd/save: POST_SAVE success", success, "msg", msg)
		
		if not success then return success, msg end
		
		local time_taken = weac.get_ms_time() - start_time
		
		
		-- print("DEBUG min_slope", min_slope, "max_slope", max_slope)
		-- print("DEBUG min_slope", math.deg(min_slope), "max_slope", math.deg(max_slope))

		minetest.log("action",
			name
			.. " used //save at "
			.. pos1
			.. " - "
			.. pos2
			.. ", saving "
			.. Vector3.volume(pos1, pos2)
			.. " nodes to "
			.. filepath
			.. " in "
			.. wea_c.format.human_time(time_taken)
		)
		return true,
			Vector3.volume(pos1, pos2) 
			.. " nodes saved in "
			.. wea_c.format.human_time(time_taken)
	end
})
