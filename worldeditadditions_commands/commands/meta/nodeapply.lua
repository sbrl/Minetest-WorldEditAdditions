local wea_c  = worldeditadditions_core
local Vector3 = wea_c.Vector3

--- Performs initial parsing of params_text for //nodeapply.
-- @param	params_text		string	The arguments to //nodeapply to parse.
-- @returns	bool,string,string,string?	1. Success bool (true = success)
-- 2. Error message if success bool == false, otherwise the string from before the delimiter
-- 3. The command name
-- 4. Any arguments to pass to the child command
function extract_parts(params_text)
	-- 1: Find delimiter
	local index, _, match = string.find(params_text, "(%s+--%s+)")
	if index == nil then
		return false, "Error: Could not find double-dash ( -- ) separator. Please ensure the double dashes have at least 1 whitespace character either side."
	end
	
	-- 2: Split into before / after delimiter
	local before = params_text:sub(1, index)
	local after = params_text:sub(index + match:len())
	
	-- 3: Wrangle command name and optional args
	local cmd_name, args_text = string.match(after, "([^%s]+)%s+(.+)")
	if not cmd_name then
		cmd_name = after
		args_text = ""
	end
	
	-- 4: Return
	return true, before, cmd_name, args_text
end

-- ███    ██  ██████  ██████  ███████  █████  ██████  ██████  ██      ██    ██
-- ████   ██ ██    ██ ██   ██ ██      ██   ██ ██   ██ ██   ██ ██       ██  ██ 
-- ██ ██  ██ ██    ██ ██   ██ █████   ███████ ██████  ██████  ██        ████  
-- ██  ██ ██ ██    ██ ██   ██ ██      ██   ██ ██      ██      ██         ██   
-- ██   ████  ██████  ██████  ███████ ██   ██ ██      ██      ███████    ██   
worldeditadditions_core.register_command("nodeapply", {
	params = "<node_a> [<node_b>] [... <node_N>] -- <command_name> <args>",
	description = "Executes the given command (automatically prepending '//'), but filters the output so only changes that affect the specified list of nodes are kept. Special node names: airlike, liquidlike.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if params_text == "" then return false, "Error: No command specified." end
		
		--- 0: Break the args apart
		local success, before, cmd_name, args_text = extract_parts(params_text)
		-- local cmd_name, args_text = params_text:match("([^%s]+)%s+(.+)")
		
		if not success then return success, before end
		
		--- 1: Parse the node list
		local parts = wea_c.split_shell(before)
		local nodelist = {}
		
		for i,part in ipairs(parts) do
			if part == "airlike" or part == "liquidlike" then
				table.insert(nodelist, part)
			elseif part:sub(1, 1) == "@" then
				-- Groups start with an @
				table.insert(nodelist, part)
			else
				local nodeid = worldedit.normalize_nodename(part)
				if not nodeid then
					return false, "Error: Unknown node name '"..part.."' at position "..tostring(i).." in node list."
				end
				table.insert(nodelist, part)
			end
		end
		
		--- 2: Parse the cmdname & args
		
		-- Note that we search the worldedit commands here, not the minetest ones
		local cmd_we = wea_c.fetch_command_def(cmd_name)
		if cmd_we == nil then
			return false, "Error: "..cmd_name.." isn't a valid command."
		end
		if cmd_we.require_pos ~= 2 and cmd_name ~= "multi" then
			return false, "Error: The command "..cmd_name.." exists, but doesn't take 2 positions and so can't be used with //airapply ('cause we can't tell how big the area is that it replaces)."
		end
		
		-- 3: Get target command to parse args
		-- Lifted from cubeapply in WorldEdit
		local args_parsed = { cmd_we.parse(args_text) }
		if not table.remove(args_parsed, 1) then
			return false, args_parsed[1]
		end
		
		return true, nodelist, cmd_we, args_parsed
	end,
	nodes_needed = function(name)
		return worldedit.volume(
			worldedit.pos1[name],
			worldedit.pos2[name]
		)
	end,
	func = function(name, nodelist, cmd, args_parsed)
		if not minetest.check_player_privs(name, cmd.privs) then
			return false, "Your privileges are insufficient to execute the command '"..cmd.."'."
		end
		
		local pos1, pos2 = Vector3.sort(
			worldedit.pos1[name],
			worldedit.pos2[name]
		)
		
		
		local success, stats = worldeditadditions.nodeapply(
			pos1, pos2,
			nodelist,
			function()
				cmd.func(name, wea_c.table.unpack(args_parsed))
			end
		)
		if not success then return success, stats end
		
		
		local time_overhead = 100 - wea_c.round((stats.fn / stats.all) * 100, 3)
		local text_time_all = wea_c.format.human_time(stats.all)
		local text_time_fn = wea_c.format.human_time(stats.fn)
		
		minetest.log("action", name.." used //nodeapply at "..pos1.." - "..pos2.." in "..text_time_all)
		return true, tostring(stats.allowed_changes).." changes allowed, "..tostring(stats.denied_changes).." filtered in "..text_time_all.." ("..text_time_fn.." fn, "..time_overhead.."% nodeapply overhead)"
	end
})
