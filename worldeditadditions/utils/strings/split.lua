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


--- Split a string into substrings separated by a pattern. -- Deprecated
-- @param	text	string	The string to iterate over
-- @param	pattern	string	The separator pattern
-- @param	plain	boolean	If true (or truthy), pattern is interpreted as a
-- 							plain string, not a Lua pattern
-- @returns	table	A sequence table containing the substrings
function worldeditadditions.dsplit(text, pattern, plain)
	local ret = {}
	for match in worldeditadditions.gsplit(text, pattern, plain) do
		table.insert(ret, match)
	end
	return ret
end

--- Split a string into substrings separated by a pattern.
-- @param	str	string	The string to iterate over
-- @param	dlm	string	The delimiter (separator) pattern
-- @param	plain	boolean	If true (or truthy), pattern is interpreted as a
-- 							plain string, not a Lua pattern
-- @returns	table	A sequence table containing the substrings
function worldeditadditions.split(str,dlm,plain)
	local pos, ret = 0, {}
	local ins, i = str:find(dlm,pos,plain)
	-- "if plain" shaves off some time in the while statement
	if plain then
		while ins do
			table.insert(ret,str:sub(pos,ins - 1))
			pos = ins + #dlm
			ins = str:find(dlm,pos,true)
		end
	else
		while ins do
			table.insert(ret,str:sub(pos,ins - 1))
			pos = i + 1
			ins, i = str:find(dlm,pos)
		end
	end
	-- print(pos..","..#str)
	if str:sub(pos,#str) ~= "" then
		table.insert(ret,str:sub(pos,#str))
	end
	return ret
end
