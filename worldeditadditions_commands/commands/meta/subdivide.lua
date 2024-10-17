local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- Test command:
--	//multi //fp set1 1330 60 5455 //fp set2 1355 35 5430 //subdivide 10 10 10 fixlight //y

local function will_trigger_saferegion(name, cmd_name, args)
	local def = wea_c.fetch_command_def(cmd_name)
	if not def then return nil, "Error: That worldedit command could not be found (perhaps it hasn't been upgraded to worldedit.register_command() yet?)" end
	if not def.parse then return nil, "Error: No parse method found (this is a bug)." end
	
	local parsed = {def.parse(args)}
	local parse_success = table.remove(parsed, 1)
	if not parse_success then return nil, table.remove(parsed, 1) end
	
	if not def.nodes_needed then return false end
	local result = def.nodes_needed(name, wea_c.table.unpack(parsed))
	if not result then return nil, result end
	if result > 10000 then return true end
	return false
end

local function emerge_stats_tostring(tbl_emerge)
	local result = {}
	for key,value in pairs(tbl_emerge) do
		if value > 0 then
			table.insert(result, string.format("%s=%d", key, value))
		end
	end
	return table.concat(result, ", ")
end

worldeditadditions_core.register_command("subdivide", {
	params = "<size_x> <size_y> <size_z> <command> <params>",
	description = "Subdivides the given worldedit area into chunks and runs a worldedit command multiple times to cover the defined region. Note that the given command must NOT be prepended with any forward slashes - just like //cubeapply.",
	privs = { worldedit = true },
	require_pos = 2,
	async = true,
	parse = function(params_text)
		local parts = wea_c.split(params_text, "%s+", false)
		
		if #parts < 4 then
			return false, "Error: Not enough arguments (try /help /subdivide)."
		end
		
		local chunk_size = {
			x = tonumber(parts[1]),
			y = tonumber(parts[2]),
			z = tonumber(parts[3])
		}
		
		if chunk_size.x == nil then return false, "Error: Invalid value for size_x (must be an integer)." end
		if chunk_size.y == nil then return false, "Error: Invalid value for size_y (must be an integer)." end
		if chunk_size.z == nil then return false, "Error: Invalid value for size_x (must be an integer)." end
		
		chunk_size.x = math.floor(chunk_size.x)
		chunk_size.y = math.floor(chunk_size.y)
		chunk_size.z = math.floor(chunk_size.z)
		
		local cmd_name = parts[4]
		
		if not wea_c.fetch_command_def(cmd_name) then
			return false, "Error: The worldedit command '"..parts[4].."' does not exist (try /help)."
		end
		
		-- success, chunk_size, command_name, args
		return true, chunk_size, parts[4], table.concat(parts, " ", 5)
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(callback, name, chunk_size, cmd_name, args)
		local time_total = wea_c.get_ms_time()
		
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local volume = worldedit.volume(pos1, pos2)
		
		local cmd = wea_c.fetch_command_def(cmd_name)
		-- Note that we don't need to check for //multi privileges, as it does it at runtime
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Error: Your privileges are unsufficient to run '"..cmd_name.."'."
		end
		
		if cmd.require_pos ~= 2 then
			return false, "Error: The WorldEdit command '"..cmd_name.."' does not take 2 region markers, so can't be executed using //subdivide."
		end
		
		-- local chunks_total = math.ceil((pos2.x - pos1.x) / (chunk_size.x - 1))
		-- 	* math.ceil((pos2.y - pos1.y) / (chunk_size.y - 1))
		-- 	* math.ceil((pos2.z - pos1.z) / (chunk_size.z - 1))
		
		local msg_prefix = "[ subdivide | "..wea_c.trim(table.concat({cmd_name, args}, " ")).." ] "
		local time_last_msg = wea_c.get_ms_time()
		
		local cmd_args_parsed = {cmd.parse(args)}
		local success = table.remove(cmd_args_parsed, 1)
		if not success then
			return false, cmd_name..": "..(cmd_args_parsed[1] or "invalid usage")
		end
			
		wea.subdivide(pos1, pos2, chunk_size, function(cpos1, cpos2, stats)
			-- Called on every subblock
			if stats.chunks_completed == 1 then
				local chunk_size_display = Vector3.new(
					stats.chunk_size.x + 1,	-- x
					stats.chunk_size.y + 1,	-- y
					stats.chunk_size.z + 1	-- z
				)
				wea_c.notify.info(name, string.format(
					"%sStarting - chunk size: %s, %d chunks total (%d nodes)",
					msg_prefix,
					tostring(chunk_size_display),
					stats.chunks_total,
					stats.volume_nodes
				))
			end
			
			wea_c.notify.suppress_for_function(name, function()
				-- We still call `worldedit.player_notify_suppress` here because we may be subdividing a WorldEdit function as opposed to one from WEA
				worldedit.player_notify_suppress(name)
				wea_c.pos.set1(name, cpos1)
				wea_c.pos.set2(name, cpos2)
				-- worldedit.pos1[name] = cpos1
				-- worldedit.pos2[name] = cpos2
				-- worldedit.marker_update(name)
				cmd.func(name, wea_c.table.unpack(cmd_args_parsed))
				if will_trigger_saferegion(name, cmd_name, args) then
					minetest.registered_chatcommands["/y"].func(name)
				end
				worldedit.player_notify_unsuppress(name)
			end)
			
			-- Send updates every 2 seconds, and after the first 3 chunks are done
			if wea_c.get_ms_time() - time_last_msg > 2 * 1000 or stats.chunks_completed == 3 or stats.chunks_completed == stats.chunks_total then
				wea_c.notify.info(name,
					string.format("%s%d / %d (~%.2f%%) complete | last chunk: %s, average: %s, %.2f%% emerge overhead, ETA: ~%s",
						msg_prefix,
						stats.chunks_completed, stats.chunks_total,
						(stats.chunks_completed / stats.chunks_total) * 100,
						wea_c.format.human_time(math.floor(stats.times.step_last)), -- the time is an integer anyway because precision
						wea_c.format.human_time(wea_c.average(stats.times.steps)),
						stats.emerge_overhead * 100,
						wea_c.format.human_time(stats.eta)
					)
				)
				time_last_msg = wea_c.get_ms_time()
			end
		end, function(_, _, stats)
			-- Called on completion
			
			wea_c.pos.set1(name, pos1)
			wea_c.pos.set2(name, pos2)
			-- worldedit.pos1[name] = pos1
			-- worldedit.pos2[name] = pos2
			-- worldedit.marker_update(name)
			
			
			minetest.log("action", string.format("%s used //subdivide at %s - %s, with %d chunks and %d total nodes in %s",
				name,
				tostring(pos1),
				tostring(pos2),
				stats.chunks_completed,
				stats.volume_nodes,
				wea_c.format.human_time(stats.times.total)
			))
			callback(true, string.format(
				"%sComplete: %d chunks processed in %s (%.2f%% emerge overhead, emerge totals: %s)",
				msg_prefix,
				stats.chunks_completed,
				wea_c.format.human_time(stats.times.total),
				stats.emerge_overhead * 100,
				emerge_stats_tostring(stats.emerge)
			))
		end)
		
		return true
	end
})
