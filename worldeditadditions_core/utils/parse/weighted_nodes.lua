
--- Parses a list of strings as a list of weighted nodes - e.g. like in
-- the //mix command. Example: "dirt 5 stone sand 2".
-- @param	parts	string[]	The list of strings to parse (try worldeditadditions.split)
-- @param	as_list	bool		If true, then table.insert() successive { node = string, weight = number } subtables when parsing instead of populating as an associative array.
-- @param	func_normalise	callable	If specified, the given function will be used to normalise node names instead of worldedit.normalize_nodename. A single argument is passed containing the un-normalised node name, and the return value is assumed to be the normalised node name.
-- @returns	table	A table in the form node_name => weight.
function worldeditadditions.parse.weighted_nodes(parts, as_list, func_normalise)
	if as_list == nil then as_list = false end
	local MODE_EITHER = 1
	local MODE_NODE = 2
	
	local result = {}
	local mode = MODE_NODE
	local last_node_name = nil
	for i, part in ipairs(parts) do
		-- print("i: "..i..", part: "..part)
		if mode == MODE_NODE then
			-- print("mode: node");
			local next
			if not func_normalise then next = worldedit.normalize_nodename(part)
			else next = func_normalise(part) end
			if not next then
				return false, "Error: Invalid node name '"..part.."'"
			end
			last_node_name = next
			mode = MODE_EITHER
		elseif mode == MODE_EITHER then
			-- print("mode: either");
			local chance = worldeditadditions.parse.chance(part, "weight")
			if not chance then
				-- print("not a chance, trying a node name")
				local node_name
				if not func_normalise then node_name = worldedit.normalize_nodename(part)
				else node_name = func_normalise(part) end
				
				if not node_name then
					return false, "Error: Invalid number '"..tostring(part).."'"
				end
				if last_node_name then
					if as_list then table.insert(result, { node = last_node_name, weight = 1 })
					else result[last_node_name] = 1 end
				end
				last_node_name = node_name
				mode = MODE_EITHER
			else
				-- print("it's a chance: ", chance, "for", last_node_name)
				chance = math.floor(chance)
				if as_list then table.insert(result, { node = last_node_name, weight = chance })
				else result[last_node_name] = chance end
				last_node_name = nil
				mode = MODE_NODE
			end
		end
	end
	if last_node_name then
		-- print("caught trailing node name: ", last_node_name)
		if as_list then table.insert(result, { node = last_node_name, weight = 1 })
		else result[last_node_name] = 1 end
	end
	
	return true, result
end
