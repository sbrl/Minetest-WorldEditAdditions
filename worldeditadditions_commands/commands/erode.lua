local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██████   ██████  ██████  ███████
-- ██      ██   ██ ██    ██ ██   ██ ██
-- █████   ██████  ██    ██ ██   ██ █████
-- ██      ██   ██ ██    ██ ██   ██ ██
-- ███████ ██   ██  ██████  ██████  ███████
worldeditadditions_core.register_command("erode", {
	params = "[<snowballs|river> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]",
	description = "**experimental** Runs the specified erosion algorithm over the given defined region. This may occur in 2d or 3d. Currently implemented algorithms: snowballs (default;2d hydraulic-like). Also optionally takes an arbitrary set of key - value pairs representing parameters to pass to the algorithm. See the full documentation for details.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			return true, "snowballs", {}
		end
		
		if params_text:find("%s") == nil then
			return true, params_text, {}
		end
		
		local algorithm, params = params_text:match("([^%s]+)%s(.+)")
		if algorithm == nil then
			return false, "Failed to split params_text into 2 parts (this is probably a bug)"
		end
		
		local success, map = wea_c.parse.map(params)
		if not success then return success, map end
		return true, algorithm, map
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, algorithm, params)
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local success, msg, stats = worldeditadditions.erode.run(
			pos1, pos2,
			algorithm, params
		)
		if not success then return success, msg end
		local time_taken = wea_c.get_ms_time() - start_time
		
		minetest.log("action", name.." used //erode "..algorithm.." at "..pos1.." - "..pos2..", adding "..stats.added.." nodes and removing "..stats.removed.." nodes in "..time_taken.."s")
		return true, msg.."\n"..stats.added.." nodes added and "..stats.removed.." nodes removed in "..wea_c.format.human_time(time_taken)
	end
})
