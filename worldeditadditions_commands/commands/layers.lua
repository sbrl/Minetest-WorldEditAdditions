local function parse_slope_range(text)
	if string.match(text, "%.%.") then
		-- It's in the form a..b
		local parts = worldeditadditions.split(text, "..", true)
		if not parts then return nil end
		if #parts ~= 2 then return false, "Error: Exactly 2 numbers may be separated by a double dot '..' (e.g. 10..45)" end
		local min_slope = tonumber(parts[1])
		local max_slope = tonumber(parts[2])
		if not min_slope then return false, "Error: Failed to parse the specified min_slope '"..tostring(min_slope).."' value as a number." end
		if not max_slope then return false, "Error: Failed to parse the specified max_slope '"..tostring(max_slope).."' value as a number." end
		
		-- math.rad converts degrees to radians
		return true, math.rad(min_slope), math.rad(max_slope)
	else
		-- It's a single value
		local max_slope = tonumber(text)
		if not max_slope then return nil end
		
		return true, 0, math.rad(max_slope)
	end
end


--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██
worldedit.register_command("layers", {
	params = "[<max_slope|min_slope..max_slope>] [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...",
	description = "Replaces the topmost non-airlike nodes with layers of the given nodes from top to bottom. Like WorldEdit for MC's //naturalize command. Optionally takes a maximum or minimum and maximum slope value. If a column's slope value falls outside the defined range, then it's skipped. Default: dirt_with_grass dirt 3",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			params_text = "dirt_with_grass dirt 3"
		end
		
		local parts = worldeditadditions.split_shell(params_text)
		local success, min_slope, max_slope
		
		if #parts > 0 then
			success, min_slope, max_slope = parse_slope_range(parts[1])
			if success then
				table.remove(parts, 1) -- Automatically shifts other values down
			end
		end
		
		if not min_slope then min_slope = 0		end
		if not max_slope then max_slope = 180	end
		
		local node_list
		success, node_list = worldeditadditions.parse.weighted_nodes(
			parts,
			true
		)
		return success, node_list, min_slope, max_slope
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, node_list, min_slope, max_slope)
		local start_time = worldeditadditions.get_ms_time()
		local changes = worldeditadditions.layers(
			worldedit.pos1[name], worldedit.pos2[name],
			node_list,
			min_slope, max_slope
		)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		-- print("DEBUG min_slope", min_slope, "max_slope", max_slope)
		-- print("DEBUG min_slope", math.deg(min_slope), "max_slope", math.deg(max_slope))
		
		minetest.log("action", name .. " used //layers at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.replaced .. " nodes and skipping " .. changes.skipped_columns .. " columns ("..changes.skipped_columns_slope.." due to slope constraints) in " .. time_taken .. "s")
		return true, changes.replaced .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped ("..changes.skipped_columns_slope.." due to slope constraints) in " .. worldeditadditions.format.human_time(time_taken)
	end
})
