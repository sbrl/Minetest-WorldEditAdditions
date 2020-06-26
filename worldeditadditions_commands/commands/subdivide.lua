
local function will_trigger_saferegion(name, cmd_name, args)
	if not worldedit.registered_commands[cmd_name] then return nil, "Error: That worldedit command could not be found (perhaps it hasn't been upgraded to worldedit.register_command() yet?)" end
	local def = worldedit.registered_commands[cmd_name]
	if not def.parse then return nil, "Error: No parse method found (this is a bug)." end
	
	local parsed = {def.parse(args)}
	local parse_success = table.remove(parsed, 1)
	if not success then return nil, table.remove(parsed, 1) end
	
	if not def.nodes_needed then return false end
	local success, result = def.nodes_needed(name, unpack(parsed))
	if not success then return nil, result end
	if result > 10000 then return true end
	return false
end

worldedit.register_command("subdivide", {
	params = "<size_x> <size_y> <size_z> <command> <params>",
	description = "Subdivides the given worldedit area into chunks and runs a worldedit command multiple times to cover the defined region. Note that the given command must NOT be prepended with any forward slashes - just like //cubeapply.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local parts = worldeditadditions.split(params_text, "%s+", false)
		
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
		
		if not worldedit.registered_commands[cmd_name] then
			return false, "Error: The worldedit command '"..parts[4].."' does not exist (try /help)."
		end
		
		-- success, chunk_size, command_name, args
		return true, chunk_size, parts[4], table.concat(parts, " ", 5)
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, chunk_size, cmd_name, args)
		local time_total = os.clock()
		
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		local volume = worldedit.volume(pos1, pos2)
		local cmd = worldedit.registered_commands[cmd_name]
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Error: Your privileges are unsufficient to run '"..cmd_name.."'."
		end
		
		worldedit.player_notify(name, worldeditadditions.vector.tostring(pos1).." - "..worldeditadditions.vector.tostring(pos2).." chunk size: "..worldeditadditions.vector.tostring(chunk_size))
		local i = 1
		local chunks_total = math.ceil((pos2.x - pos1.x) / chunk_size.x)
			* math.ceil((pos2.y - pos1.y) / chunk_size.y)
			* math.ceil((pos2.z - pos1.z) / chunk_size.z)
		
		local time_chunks = {}
		for z = pos2.z, pos1.z, -chunk_size.z do
			for y = pos2.y, pos1.y, -chunk_size.y do
				for x = pos2.x, pos1.x, -chunk_size.x do
					local c_pos2 = { x = x, y = y, z = z }
					local c_pos1 = {
						x = x - chunk_size.x,
						y = y - chunk_size.y,
						z = z - chunk_size.z
					}
					if c_pos1.x < pos1.x then c_pos1.x = pos1.x end
					if c_pos1.y < pos1.y then c_pos1.y = pos1.y end
					if c_pos1.z < pos1.z then c_pos1.z = pos1.z end
					
					
					
					local time_this = os.clock()
					worldedit.pos1[name] = c_pos1
					worldedit.pos2[name] = c_pos2
					cmd.func(name, args)
					if will_trigger_saferegion(name, cmd_name, args) then
						minetest.chatcommands["/y"].func()
					end
					time_this = os.clock() - time_this
					
					worldedit.player_notify(name,
						"[ //subdivide "..cmd_name.." "..args.." ] "
						..i.." / "..chunks_total.." (~"
						..string.format("%.2f", (i / chunks_total) * 100).."%) complete | "..
						worldeditadditions.vector.tostring(c_pos1).." - "..
						worldeditadditions.vector.tostring(c_pos2).."("..worldedit.volume(c_pos1, c_pos2).." nodes)"
					)
					
					i = i + 1
				end
			end
		end
		worldedit.pos1[name] = pos1
		worldedit.pos2[name] = pos2
		time_total = os.clock() - time_total
		
		
		minetest.log("action", name.." used //subdivide at "..worldeditadditions.vector.tostring(pos1).." - "..worldeditadditions.vector.tostring(pos2)..", with "..i.." chunks and "..worldedit.volume(pos1, pos2).." total nodes in "..time_total.."s")
		return true, "/subdivide complete"
	end
})
