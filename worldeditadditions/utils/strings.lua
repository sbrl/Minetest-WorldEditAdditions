-- Licence: GPLv2 (MPL-2.0 is compatible, so we can use this here)
-- Source: https://stackoverflow.com/a/43582076/1460422

-- gsplit: iterate over substrings in a string separated by a pattern
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: iterator
--
-- Usage:
-- for substr in gsplit(text, pattern, plain) do
--   doSomething(substr)
-- end
function worldeditadditions.gsplit(text, pattern, plain)
	local splitStart, length = 1, #text
	return function ()
		if splitStart then
			local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
			local ret
			if not sepStart then
				ret = string.sub(text, splitStart)
				splitStart = nil
			elseif sepEnd < sepStart then
				-- Empty separator!
				ret = string.sub(text, splitStart, sepStart)
				if sepStart < length then
					splitStart = sepStart + 1
				else
					splitStart = nil
				end
			else
				ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
				splitStart = sepEnd + 1
			end
			return ret
		end
	end
end


-- split: split a string into substrings separated by a pattern.
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: table (a sequence table containing the substrings)
function worldeditadditions.split(text, pattern, plain)
	local ret = {}
	for match in worldeditadditions.gsplit(text, pattern, plain) do
		table.insert(ret, match)
	end
	return ret
end


--- Pads str to length len with char from right
-- @source https://snipplr.com/view/13092/strlpad--pad-string-to-the-left
function worldeditadditions.str_padend(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end
--- Pads str to length len with char from left
-- Adapted from the above
function worldeditadditions.str_padstart(str, len, char)
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str
end

function worldeditadditions.string_starts(str,start)
   return string.sub(str,1,string.len(start))==start
end

--- Turns an associative node_id → count table into a human-readable list.
-- Works well with worldeditadditions.make_ascii_table().
function worldeditadditions.node_distribution_to_list(distribution, nodes_total)
	local distribution_data = {}
	for node_id, count in pairs(distribution) do
		table.insert(distribution_data, {
			count,
			tostring(worldeditadditions.round((count / nodes_total) * 100, 2)).."%",
			minetest.get_name_from_content_id(node_id)
		})
	end
	return distribution_data
end

--- Makes a human-readable table of data.
-- Data should be a 2D array - i.e. a table of tables. The nested tables should
-- contain a list of items for a single row.
-- If total is specified, then a grand total is printed at the bottom - this is
-- useful when you want to print a node list - works well with
-- worldeditadditions.node_distribution_to_list().
function worldeditadditions.make_ascii_table(data, total)
	local extra_padding = 2
	local result = {}
	local max_lengths = {}
	for y = 1, #data, 1 do
		for x = 1, #data[y], 1 do
			if not max_lengths[x] then
				max_lengths[x] = 0
			end
			max_lengths[x] = math.max(max_lengths[x], #tostring(data[y][x]) + extra_padding)
		end
	end
		
	for _key, row in ipairs(data) do
		local row_result = {}
		for i = 1, #row, 1 do
			row_result[#row_result + 1] = worldeditadditions.str_padend(tostring(row[i]), max_lengths[i], " ")
		end
		result[#result+1] = table.concat(row_result, "")
	end
	
	if total then
		result[#result+1] = string.rep("=", 6 + #tostring(total) + 6).."\n"..
		"Total "..total.." nodes\n"
	end
	
	-- TODO: Add multi-column support here
	return table.concat(result, "\n")
end



function worldeditadditions.parse_weighted_nodes(parts)
	local MODE_EITHER = 1
	local MODE_NODE = 2
	
	local result = {}
	local mode = MODE_NODE
	local last_node_name = nil
	for i, part in ipairs(parts) do
		print("i: "..i..", part: "..part)
		if mode == MODE_NODE then
			print("mode: node");
			local next = worldedit.normalize_nodename(part)
			if not next then
				return false, "Error: Invalid node name '"..part.."'"
			end
			last_node_name = next
			mode = MODE_EITHER
		elseif mode == MODE_EITHER then
			print("mode: either");
			local chance = tonumber(part)
			if not chance then
				local node_name = worldedit.normalize_nodename(part)
				if not node_name then
					return false, "Error: Invalid number '"..chance.."'"
				end
				if last_node_name then
					result[last_node_name] = 1
				end
				last_node_name = node_name
				mode = MODE_EITHER
			else
				result[last_node_name] = math.floor(chance)
				mode = MODE_NODE
			end
		end
	end
	if last_node_name then
		result[last_node_name] = 1
	end
	
	return true, result
end
