-- Licence: GPLv2 (MPL-2.0 is compatible, so we can use this here)
-- Source: https://stackoverflow.com/a/43582076/1460422

local we_c = worldeditadditions_commands


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
function we_c.gsplit(text, pattern, plain)
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
function we_c.split(text, pattern, plain)
	local ret = {}
	for match in we_c.gsplit(text, pattern, plain) do
		table.insert(ret, match)
	end
	return ret
end
