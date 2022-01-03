--- Uncomment these 2 lines to run in standalone mode
-- worldeditadditions = { parse = {  } }
-- function worldeditadditions.trim(str) return (str:gsub("^%s*(.-)%s*$", "%1")) end


--- The main tokeniser. Splits the input string up into space separated tokens, except when said spaces are inside { curly braces }.
-- Note that the outermost set of curly braces are stripped.
-- @param   str     string  The input string to tokenise.
-- @returns string[]        A list of tokens
local function tokenise(str)
	if type(str) ~= "string" then return false, "Error: Expected input of type string." end
	str = str:gsub("%s+", " ") -- Replace all runs of whitespace with a single space
	
	-- The resulting tokens
	local result = {}
	
	local nested_depth = 0     -- The nested depth inside { and } we're currently at
	local nested_stack = {}    -- Stack of starting positions of curly brace {  } blocks
	local scanpos = 1          -- The current position we're scanning
	while scanpos <= #str do
		-- Find the next character of interest
		local nextpos = str:find("[%s{}]", scanpos)
		-- If it's nil, then cleanup and return
		if nextpos == nil then
			if nested_depth > 0 then
				-- Handle unclosed brace groups
				return false, "Error: Unclosed brace group detected."
			else
				-- Make sure we catch any trailing parts
				local str_trailing = str:sub(scanpos)
				if #str_trailing then table.insert(result, str_trailing) end
				return true, result
			end
		end
		
		-- Extract the character in question
		local char = str:sub(nextpos, nextpos)
		
		if char == "}" then
			if nested_depth > 0 then
				-- Decrease the nested depth
				nested_depth = nested_depth - 1
				-- Pop the start of this block off the stack and find this block's contents
				local block_start = table.remove(nested_stack, #nested_stack)
				local substr = str:sub(block_start, nextpos - 1)
				if #substr > 0 and nested_depth == 0 then table.insert(result, substr) end
			end
		elseif char == "{" then
			-- Increase the nested depth, and store this position on the stack for later
			nested_depth = nested_depth + 1
			table.insert(nested_stack, nextpos + 1)
		else
			-- It's a space! Extract a part, but only if the nested depth is 0 (i.e. we're not inside any braces).
			local substr = str:sub(scanpos, nextpos - 1)
			if #substr > 0 and nested_depth == 0 then table.insert(result, substr) end
		end
		-- Move the scanning position up to just after the character we've just
		-- found and handled
		scanpos = nextpos + 1
	end
	
	-- Handle any trailing bits
	local str_trailing = str:sub(scanpos)
	if #str_trailing > 0 then table.insert(result, str_trailing) end
	
	return true, result
end

--- Recombines a list of tokens into a list of commands.
-- @param   parts   string[]    The tokens from tokenise(str).
-- @returns         string[]	The tokens, but run through trim() & grouped into commands (1 element in the list = 1 command)
local function recombine(parts)
	local result = {}
	local acc = {}
	for i, value in ipairs(parts) do
		value = worldeditadditions.trim(value)
		if value:sub(1, 1) == "/" and #acc > 0 then
			table.insert(result, table.concat(acc, " "))
			acc = {}
		end
		table.insert(acc, value)
	end
	if #acc > 0 then table.insert(result, table.concat(acc, " ")) end
	return result
end


--- Tokenises a string of multiple commands into an array of individual commands.
-- Preserves the forward slash at the beginning of each command name.
-- Also supports arbitrarily nested and complex curly braces { } for grouping
-- commands together that would normally be split apart.
-- 
-- Simple example:
-- INPUT: //1 //2 //outset 25 //fixlight
-- OUTPUT: { "//1", "//2", "//outset 25", "//fixlight" }
-- 
-- Example with curly braces:
-- INPUT: //1 //2 //outset 50 {//many 5 //multi //fixlight //clearcut}
-- OUTPUT: { "//1", "//2", "//outset 50", "//many 5 //multi //fixlight //clearcut"}
-- 
-- @param	command_str		str		The command string to operate on.
-- @returns	bool,(string[]|string)	If the operation was successful, then true followed by a table of strings is returned. If the operation was not successful, then false followed by an error message (as a single string) is returned instead.
function worldeditadditions.parse.tokenise_commands(command_str)
	local success, result = tokenise(command_str)
	if not success then return success, result end
	return true, recombine(result)
end


----- Test harness code -----
-----------------------------
-- local function printparts(tbl)
-- 	for key,value in ipairs(tbl) do
-- 		print(key..": "..value)
-- 	end
-- end
-- 
-- local function test_input(input)
-- 	local success, result = worldeditadditions.parse.tokenise_commands(input)
-- 	if success then
-- 		printparts(result)
-- 
-- 		-- print("RECOMBINED:")
-- 		-- printparts(recombine(result))
-- 	else
-- 		print(result)
-- 	end
-- 
-- end
-- 
-- print("\n\n\n*** 1 ***")
-- test_input("//multi //1 //cubeapply 10 set dirt")
-- print("\n\n\n*** 2 ***")
-- test_input("//multi //1 //2 //outset 50 {//many 5 //multi //fixlight //clearcut}")
-- print("\n\n\n*** 3 ***")
-- test_input("//multi //1 //2 //outset 50 {//many 5 //multi //ellipsoid 10 5 7 glass //clearcut}")
-- print("\n\n\n*** 4 ***")
-- test_input("//multi //1 //2 //outset 50 {//many 5 //multi //ellipsoid 10 5 7 glass //clearcut //many {//set dirt //fixlight}}")
-- print("\n\n\n*** 5 ***")
-- test_input("a { b c d { e f { g h i }j} k l m n}o p")
-- print("\n\n\n*** 6 ***")
-- test_input("a { b c d } e f {{ g h i }j k l m n}o p")
