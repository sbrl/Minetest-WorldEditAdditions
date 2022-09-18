local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ██████  ███████ ██████  ██       █████   ██████ ███████ ███    ███ ██ ██   ██
-- ██   ██ ██      ██   ██ ██      ██   ██ ██      ██      ████  ████ ██  ██ ██
-- ██████  █████   ██████  ██      ███████ ██      █████   ██ ████ ██ ██   ███
-- ██   ██ ██      ██      ██      ██   ██ ██      ██      ██  ██  ██ ██  ██ ██
-- ██   ██ ███████ ██      ███████ ██   ██  ██████ ███████ ██      ██ ██ ██   ██
wea_c.register_command("replacemix", {
	params = "<target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ...",
	description = "Replaces target_node with a mix of other nodes. Functions simmilarly to //mix. <chance> is optional and the chance to replace the target node at all. replace_node_a is the node to replace target_node with. If multiple nodes are specified in a space separated list, then when replacing an instance of target_node one is randomly chosen from the list. Just like with //mix, if a positive integer is present after a replace_node, that adds a weighting to that particular node making it more common.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			return false, "Error: No arguments specified"
		end
		
		local parts = wea_c.split_shell(params_text)
		
		local target_node = nil
		local target_node_chance = 1
		local replace_nodes = {}
		
		local mode = "target_node"
		local last_node_name = nil
		for i, part in ipairs(parts) do
			if mode == "target_node" then
				target_node = worldedit.normalize_nodename(part)
				if not target_node then
					return false, "Error: Invalid target_node name"
				end
				mode = "target_chance"
			elseif mode == "target_chance" and wea_c.parse.chance(part) then
				target_node_chance = wea_c.parse.chance(part)
				mode = "replace_node"
			elseif (mode == "target_chance" and not wea_c.parse.chance(part, "weight")) or mode == "replace_node" then
				mode = "replace_node"
				if wea_c.parse.chance(part, "weight") then
					if not last_node_name then
						return false, "Error: No previous node name was found (this is a probably a bug)."
					end
					replace_nodes[last_node_name] = math.floor(wea_c.parse.chance(part, "weight"))
				else
					if last_node_name and not replace_nodes[last_node_name] then
						replace_nodes[last_node_name] = 1
					end
					
					local node_name = worldedit.normalize_nodename(part)
					if not node_name then
						return false, "Error: Invalid replace node name '"..part.."'."
					end
					last_node_name = node_name
				end
			end
		end
		if not target_node then return false, "Error: No target node specified." end
		if not last_node_name then return false, "Error: At least 1 replace node must be specified." end
		
		if not replace_nodes[last_node_name] then
			replace_nodes[last_node_name] = 1
		end
		
		-- We unconditionally math.floor here because when we tried to test for it directly it was unreliable
		return true, target_node, target_node_chance, replace_nodes
	end,
	nodes_needed = function(name) -- target_node, target_node_chance, replace_nodes
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, target_node, target_node_chance, replace_nodes)
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])

		local success, changed, candidates, distribution = wea.replacemix(
			worldedit.pos1[name], worldedit.pos2[name],
			target_node,
			target_node_chance,
			replace_nodes
		)
		if not success then
			return success, changed
		end
		
		local nodes_total = worldedit.volume(pos1, pos2)
		local percentage_replaced = wea_c.round((changed / candidates)*100, 2)
		local distribution_table = wea_c.format.node_distribution(
			distribution,
			changed,
			true -- Add a grand total to the bottom
		)
		
		local time_taken = wea_c.get_ms_time() - start_time
		
		
		minetest.log("action", name .. " used //replacemix at "..pos1.." - "..pos2..", replacing " .. changed.." nodes (out of "..nodes_total.." nodes) in "..time_taken.."s")
		
		return true, distribution_table..changed.." out of "..candidates.." (~"..percentage_replaced.."%) candidates replaced in "..wea_c.format.human_time(time_taken)
	end
})
