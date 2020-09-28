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

--- Equivalent to string.startsWith in JS
-- @param	str		string	The string to operate on
-- @param	start	number	The start string to look for
-- @returns	bool	Whether start is present at the beginning of str
function worldeditadditions.string_starts(str,start)
   return string.sub(str,1,string.len(start))==start
end

--- Prints a 2d array of numbers formatted like a JS TypedArray (e.g. like a manip node list or a convolutional kernel)
-- In other words, the numbers should be formatted as a single flat array.
-- @param	tbl		number[]	The ZERO-indexed list of numbers
-- @param	width	number		The width of 2D array.
function worldeditadditions.print_2d(tbl, width)
	print("==== count: "..#tbl..", width:"..width.." ====")
	local display_width = 1
	for _i,value in pairs(tbl) do
		display_width = math.max(display_width, #tostring(value))
	end
	display_width = display_width + 2
	local next = {}
	for i=0, #tbl do
		table.insert(next, worldeditadditions.str_padstart(tostring(tbl[i]), display_width))
		if #next == width then
			print(table.concat(next, ""))
			next = {}
		end
	end
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

--- Parses a list of strings as a list of weighted nodes - e.g. like in the //mix command.
-- @param	parts	string[]	The list of strings to parse (try worldeditadditions.split)
-- @param	as_list	bool		If true, then table.insert() successive { node = string, weight = number } subtables when parsing instead of populating as an associative array.
-- @param	func_normalise	callable	If specified, the given function will be used to normalise node names instead of worldedit.normalize_nodename. A single argument is passed containing the un-normalised node name, and the return value is assumed to be the normalised node name.
-- @returns	table	A table in the form node_name => weight.
function worldeditadditions.parse_weighted_nodes(parts, as_list, func_normalise)
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
			local chance = tonumber(part)
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

function worldeditadditions.parse_map(params_text)
	local result = {}
	local parts = worldeditadditions.split(params_text, "%s+", false)
	
	local last_key = nil
	for i, part in ipairs(parts) do
		if i % 2 == 0 then -- Lua starts at 1 :-/
			-- Try converting to a number to see if it works
			local part_converted = tonumber(part)
			if as_number == nil then part_converted = part end
			result[last_key] = part
		else
			last_key = part
		end
	end
	return true, result
end

function worldeditadditions.map_stringify(map)
	local result = {}
	for key, value in pairs(map) do
		table.insert(result, key.."\t"..value)
	end
	return table.concat(result, "\n")
end

--- Converts a float milliseconds into a human-readable string.
-- Ported from PHP human_time from Pepperminty Wiki: https://github.com/sbrl/Pepperminty-Wiki/blob/fa81f0d/core/05-functions.php#L82-L104
-- @param	ms		float	The number of milliseconds to convert.
-- @return	string	A human-readable string representing the input ms.
function worldeditadditions.human_time(ms)
	local tokens = {
		{ 31536000 * 1000, 'year' },
		{ 2592000 * 1000, 'month' },
		{ 604800 * 1000, 'week' },
		{ 86400 * 1000, 'day' },
		{ 3600 * 1000, 'hr' },
		{ 60 * 1000, 'min' },
		{ 1 * 1000, 's' },
		{ 1, 'ms'}
	}
	
	for _,pair in pairs(tokens) do
		if ms > pair[1] or pair[2] == "ms" then
			local unit = pair[2]
			if ms > 60 * 1000 and math.floor(ms / pair[1]) > 1 then
				unit = unit.."s"
			end
			return string.format("%.2f", ms / pair[1])..unit
		end
	end
end


--- Makes a seed from a string.
-- If the input is a number, it is returned as-is.
-- If the input is a string and can be converted to a number with tonumber(),
-- the output of tonumber() is returned.
-- Otherwise, the string is converted to a number via a simple hashing algorithm
-- (caution: certainlly NOT crypto-secure!).
-- @param   {string}    str     The string to convert.
-- @source https://stackoverflow.com/a/2624210/1460422 The idea came from here
function worldeditadditions.makeseed(str)
    if type(str) == "number" then return str end
    if tonumber(str) ~=  nil then return tonumber(str) end
    local result = 0
    for i = 1, #str do
        result = (result*91) + (string.byte(str:sub(i, i)) * 31)
    end
    return result
end
